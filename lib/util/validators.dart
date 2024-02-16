createNonEmptyValidator(fieldName) => (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a $fieldName';
      }
      return null;
    };
