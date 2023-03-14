enum ChatType { public, private }

extension GroupType on ChatType {
  String capitalize() {
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }
}
