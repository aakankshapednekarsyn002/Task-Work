import json
import csv

with open("employees.json", "r") as f:
    data = json.load(f)


def flattenfile(x, result):

    if isinstance(x, (int, float, str)):
        result.append(x)

    elif isinstance(x, dict):
        for value in x.values():
            flattenfile(value, result)

    elif x is None:
        result.append("")

    elif isinstance(x, list) :
         result.append("|".join(map(str, x)))

    return result

final_output = []

for item in data:
    row = []
    flattenfile(item, row)
    final_output.append(row)

final_output.insert(0, [
    "employee_id",
    "employee_name",
    "joining_year",
    "joining_department",
    "salary",
    "skills"
])


with open("Employees_output.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(final_output)

print("Flattening completed")
