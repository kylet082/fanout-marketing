import setuptools

with open("README.md", 'r') as fh:
    long_description = fh.read()

setuptools.setup(
    name="utils-kgt-dev",
    version="0.0.1-beta",
    author="Kyle Truebody",
    author_email="kyletruebody@gmail.com",
    description="",
    long_description=long_description,
    url="https://github.com/kylet082/fanout-marketing/tree/main/modules/utils",
    packages=setuptools.find_packages(
        where="src",
        include=['*'],
        exclude=['test']
    ),
    package_dir={"":"src"},
    install_requires=[],
    classifiers=[
        "Programming Language :: Python 3",
        "License :: TBD :: TBD",
        "Opertaing System :: OS Independent"
    ],
    python_requires='>=3.8'
)