#!/bin/bash

WORK_DIR=work
RELEASE_DIR=release
RELEASE_NAME=DTED2-Denmark.zip
RELEASE_UUID=$(uuidgen)
RELEASE_DIRHASH=$(openssl rand -hex 16)

# Create Folders
mkdir -p ${RELEASE_DIR}
mkdir -p ${WORK_DIR}/MANIFEST

echo "Moving DTED files to ${WORK_DIR}"

cp -R repo/ ${WORK_DIR}/${RELEASE_DIRHASH}

echo 'Creating datapackage:' ${RELEASE_NAME}

cat <<-EOF > "${WORK_DIR}/MANIFEST/manifest.xml"
<MissionPackageManifest version="2">
    <Configuration>
        <Parameter name="uid" value="${RELEASE_UUID}"/>
        <Parameter name="name" value="${RELEASE_NAME}"/>
    </Configuration>
    <Contents>
EOF

FILES=()
while IFS=  read -r -d $'\0'; do
    FILES+=("$REPLY")
    echo -e "       <Content ignore=\"false\" zipEntry=\"${REPLY#release/}\"/>" >> ${WORK_DIR}/MANIFEST/manifest.xml
done < <(find ${WORK_DIR}/${RELEASE_DIRHASH}/* -iname "*.dt*" -print0)

echo -e "\t</Contents>\n</MissionPackageManifest>" >> ${WORK_DIR}/MANIFEST/manifest.xml


echo 'Packing datapackage:' ${RELEASE_NAME}

rm -rf ${RELEASE_DIR}/*

cd ./${WORK_DIR}
zip -9 -r ../${RELEASE_DIR}/${RELEASE_NAME} *
cd ..
rm -rf ${WORK_DIR}

echo "Done"
echo $(du -kh "${RELEASE_DIR}/${RELEASE_NAME}" | cut -f1)
