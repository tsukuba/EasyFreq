void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
  
  //2 out clk
  //3 out clear
  //3 in  dataIn
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, INPUT);

}

void loop() {
  // put your main code here, to run repeatedly:
  unsigned long result = 0;
  digitalWrite(3, HIGH);
  digitalWrite(3, LOW);
  
  for(int i = 0; i < 32; i++){
    unsigned long input = digitalRead(4);
    result |= (input << i);
    digitalWrite(2, HIGH);
    digitalWrite(2, LOW);
  }
  
  Serial.print(String(result));
  Serial.print("\n");

}
