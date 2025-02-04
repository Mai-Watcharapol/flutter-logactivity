// Interface ของ Engine
abstract class Engine {
  void start();
  void stop();
  String getDetails();
}

// การสร้างคลาสเครื่องยนต์ประเภทต่างๆ
class ElectricEngine implements Engine {
  @override
  void start() {
    print("Electric engine starting...");
  }

  @override
  void stop() {
    print("Electric engine stopping...");
  }

  @override
  String getDetails() {
    return "Electric engine with high efficiency and low noise.";
  }
}

class PetrolEngine implements Engine {
  @override
  void start() {
    print("Petrol engine starting...");
  }

  @override
  void stop() {
    print("Petrol engine stopping...");
  }

  @override
  String getDetails() {
    return "Petrol engine with high power output and performance.";
  }
}

class HybridEngine implements Engine {
  @override
  void start() {
    print("Hybrid engine starting...");
  }

  @override
  void stop() {
    print("Hybrid engine stopping...");
  }

  @override
  String getDetails() {
    return "Hybrid engine with combination of electric and petrol engines.";
  }
}

// คลาส Car ที่สามารถเปลี่ยนเครื่องยนต์ได้
class Car {
  Engine _engine;

  Car(this._engine);

  void setEngine(Engine engine) {
    _engine = engine;
  }

  void startEngine() {
    _engine.start();
  }

  void stopEngine() {
    _engine.stop();
  }

  void showEngineDetails() {
    print(_engine.getDetails());
  }
}

void main() {
  // สร้างรถยนต์พร้อมกับเครื่องยนต์ไฟฟ้า
  Car car = Car(ElectricEngine());
  car.startEngine();
  car.showEngineDetails();
  car.stopEngine();

  // เปลี่ยนเครื่องยนต์เป็นเครื่องยนต์น้ำมัน
  car.setEngine(PetrolEngine());
  car.startEngine();
  car.showEngineDetails();
  car.stopEngine();

  // เปลี่ยนเครื่องยนต์เป็นเครื่องยนต์ไฮบริด
  car.setEngine(HybridEngine());
  car.startEngine();
  car.showEngineDetails();
  car.stopEngine();
}
