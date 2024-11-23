unit StabilityAI.Consts;

{-------------------------------------------------------------------------------

      Github repository :  https://github.com/MaxiDonkey/DelphiStabilityAI
      Visit the Github repository for the documentation and use examples

 ------------------------------------------------------------------------------}

interface

const
  PromptMax = 10000;
  SeedMax = 4294967294;

resourcestring
  PromptExceptionMessage = '%s too long max %d : (%d)';
  IntegerExceptionMessage = '%s must be in [%d..%d] : %d';
  FloatExceptionMessage = '%s must be in [%s..%s] : %s';
  DataFileEmptyExceptionMessage = 'No data to save.';
  StreamEmptyExceptionMessage = 'The stream is empty.';
  DataEmptyExceptionMessage = 'The model data string is empty.';
  MultipleOfExceptionMessage = 'The Value must be multiple of %d and greater than %d : %d';
  FileNameNotNullExceptionMessage = 'The filename can''t be null';
  FinishReasonUnknownExceptionMessage = 'Finish reason unkonw.';

implementation

end.
