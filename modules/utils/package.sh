# Build whl and install to activate py environment

# For this module it so we can support local development, making the library available
# in dev virtual env
function build_py {
  python -m pip install --upgrade setuptools wheel
  python ./setup.py sdist bdist_wheel
  python -m pip install --target ${1} ./dist/utils_kgt_dev-0.0.1b0-py3-none-any.whl
}