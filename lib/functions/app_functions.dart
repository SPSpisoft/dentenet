
import '../data/app.dart';
import '../public/public_variables.dart';

void setCurrentEmployer(ClsMember employer){
  Globals.currentEmployer.clear();
  Globals.currentEmployer.add(employer);
}

ClsMember? getCurrentEmployer(){
  if(Globals.currentEmployer.isNotEmpty) {
    return Globals.currentEmployer.first;
  }
  return null;
}

void setCurrentPatient(ClsPatientInfo patientInfo){
  Globals.currentPatient.clear();
  Globals.currentPatient.add(patientInfo);
}

ClsPatientInfo? getCurrentPatient(){
  if(Globals.currentPatient.isNotEmpty) {
    return Globals.currentPatient.first;
  }
  return null;
}