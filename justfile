PYTHON_BINARY := "python3"
VIRTUAL_ENV := "venv"
VIRTUAL_BIN := VIRTUAL_ENV / bin

# Remove the virtual environment and clear out .pyc files
clean:
    rm -rf {{VIRTUAL_ENV}} dist *.egg-info .coverage
    find . -name '*.pyc' -delete

# Install the project locally
install:
    {{PYTHON_BINARY}} -m venv {{VIRTUAL_ENV}}
    {{VIRTUAL_BIN}}/pip install -r requirements.txt
