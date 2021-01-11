# Build whl and install to activate py environment


function build_py {
  python -m pip install --upgrade setuptools wheel
  python ./setup.py sdist bdist_wheel
  python -m pip install --target ${1} ./dist/mailchimp_service_kgt_dev-0.0.1b0-py3-none-any.whl
}