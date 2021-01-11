import setuptools

with open("README.md", 'r') as fh:
    long_description = fh.read()

setuptools.setup(
    name="aws-utils-kgt-dev",
    version="0.0.1-beta",
    author="Kyle Truebody",
    author_email="kyletruebody@gmail.com",
    description="",
    long_description=long_description,
    url="https://github.com/KyleT082/EnterpriseServices/tree/develop/modules/email-services",
    packages=setuptools.find_packages(
        where="src",
        include=['*'],
        exclude=['test']
    ),
    package_dir={"":"src"},
    install_requires=[
        'boto3'
    ],
    classifiers=[
        "Programming Language :: Python 3",
        "License :: TBD :: TBD",
        "Opertaing System :: OS Independent"
    ],
    python_requires='>=3.8'
)