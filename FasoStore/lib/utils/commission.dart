import 'constants.dart';

double calculateCommission(double amount) {
  return amount * Constants.commissionRate;
}

double calculateTotalWithCommission(double amount) {
  return amount + calculateCommission(amount);
}
