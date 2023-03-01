String getUserStatus(bool isClone) {
  if (isClone) {
    return "receiver";
  } else {
    return "sender";
  }
}
