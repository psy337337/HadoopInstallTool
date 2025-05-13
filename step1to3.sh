
#!/bin/bash

./HadoopInstallTool/install.sh
./HadoopInstallTool/hostset.sh $@
./HadoopInstallTool/makeUser.sh
