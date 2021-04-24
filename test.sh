docker build -q -t xra .
docker run --rm --name xra -d -p 8080:8080 xra

sleep 5

RESULT=`curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"id":"abcd", "opcode":168,"state":{"a":92,"b":120,"c":66,"d":5,"e":15,"h":10,"l":2,"flags":{"sign":false,"zero":false,"auxCarry":true,"parity":false,"carry":true},"programCounter":1,"stackPointer":2,"cycles":0}}' \
  http://localhost:8080/api/v1/execute`
EXPECTED='{"id":"abcd", "opcode":168,"state":{"a":36,"b":120,"c":66,"d":5,"e":15,"h":10,"l":2,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":true,"carry":false},"programCounter":1,"stackPointer":2,"cycles":4}}'

docker kill xra

DIFF=`diff <(jq -S . <<< "$RESULT") <(jq -S . <<< "$EXPECTED")`

if [ $? -eq 0 ]; then
    echo -e "\e[32mXRA Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mXRA Test Fail  \e[0m"
    echo "$RESULT"
    echo "$DIFF"
    exit -1
fi