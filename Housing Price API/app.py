from fastapi import FastAPI , Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import os
import pickle
import numpy as np
import logging
import time

app = FastAPI()

# Monitoring (Logging)

logger = logging.getLogger("app_logger")
logger.setLevel(logging.INFO)

file_handler = logging.FileHandler("app.log")
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
file_handler.setFormatter(formatter)

if not logger.handlers:
    logger.addHandler(file_handler)

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    global failed_requests
    failed_requests += 1 
    
    logger.error(f"Validation Error: {exc.errors()}")
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors()}
    )


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(BASE_DIR,"Model", "house_model.pkl")

with open(model_path, "rb") as f:
    model = pickle.load(f)

# Input 

class HouseInput(BaseModel):
    area: float
    bedrooms: int
    bathrooms: int
    stories: int
    mainroad: int
    guestroom: int
    basement: int
    hotwaterheating: int
    airconditioning: int
    parking: int
    prefarea: int
    furnishingstatus: int

total_requests = 0
failed_requests = 0
total_latency = 0


# Health API

@app.get("/health")
def health():
    return {"status": " Healthy"}

#  Prediction API

@app.post("/predict")
def predict(data: HouseInput):
    global total_requests, failed_requests, total_latency

    total_requests += 1

    start_time = time.time()

    try:
       
        input_data = data.dict()
        for key, value in input_data.items():
            if value < 0:
                raise ValueError(f"{key} cannot be negative")
    
        features = [[
            data.area,
            data.bedrooms,
            data.bathrooms,
            data.stories,
            data.mainroad,
            data.guestroom,
            data.basement,
            data.hotwaterheating,
            data.airconditioning,
            data.parking,
            data.prefarea,
            data.furnishingstatus
        ]]

        prediction = model.predict(features)

        latency = time.time() - start_time
        total_latency += latency

        logger.info(f"Input: {input_data}")
        logger.info(f"Prediction: {float(prediction[0])}")
        logger.info(f"Response time: {latency}")

        return {
            "prediction": float(prediction[0]),
            "latency": latency
        }

    except Exception as e:
        failed_requests += 1

        logger.error(f"Error occurred: {str(e)} | Input: {data.dict()}")

        return {"error": str(e)}


#  Monitoring API

@app.get("/metrics")
def metrics():
    error_rate = (failed_requests / total_requests) if total_requests > 0 else 0
    avg_latency = (total_latency / total_requests) if total_requests > 0 else 0

    return {
        "total_requests": total_requests,
        "failed_requests": failed_requests,
        "error_rate": error_rate,
        "average_latency": avg_latency
    }

# Requirements:
# fastapi
# uvicorn[standard]
# numpy
# scikit-learnS