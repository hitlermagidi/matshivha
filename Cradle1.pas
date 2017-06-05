program Cradle;

{ Constant Declarations }

const TAB = ^|;

{ Variable Declarations }

var Look: char;

{ Read New Character From Input Stream }

procedure GetChar;
begin
	Read(Look);
end;

{ Report an Error }

procedure Error(s: string);
begin
	WriteLn;
	WriteLn(^G, 'Error: ', s, '.');
end;

{ Report Error and Halt }

procedure Abort(s: string);
begin
	Error(s);
	Halt;
end;

{ Report What Was Expected }

procedure Expected(s: string);
begin
	Abort(s + 'Expected');
end;

{ Match a Specific Input Character }

procedure Match(x: char);
begin
	if Look = x then GetChar
	else Expected('''' + x + '''');
end;

{ Recognize an Alpha Character }

function IsAlpha(c: char): boolean;
begin
	IsAlpha := upcase(c) in ['A'..'Z'];
end;

{ Recognize a Decimal Digit }

function IsDigit(c: char): boolean;
begin
 	IsDigit := c in ['0'..'9'];
end;

{ Get an Identifier }

function GetName: char;
begin
 	if not IsAlpha(Look) then Expected('Name');
 	GetName := Upcase(look);
 	GetChar;
end;

{ Get a Number }

function GetNum: char;
begin
 	if not IsDigit(Look) then Expected('Interger');
 	GetNum := Look;
 	GetChar;
end;

{ Output a String With Tab }

procedure Emit(s: string);
begin
 	Write(TAB, s);
end;

{ Output a String With Tab and CRLF }
procedure EmitLn(s: string);
begin
 	Emit(s);
 	WriteLn;
end;

{ Parse and Translate a Math Facter }

procedure Factor;
begin
	EmitLn('MOVE #' + GetNum + ',D0')
end;

{ Recognize and Translate a Multiply }
procedure Multiply;
begin
	Match('*');
	Factor;
	EmitLn('MUL D1, D0');
end;

{ Recognize and Translate a Divide }

procedure Divide;
begin 
	Match('/');
	Factor;
	EmitLn('DIVS D1, D0');
end;

{ Parse and Translate a Math Term }

procedure Term;
begin
	Factor;
	while Look in ['*', '/'] do begin
	EmitLn('MOVE D0, D1');
	case Look of
	'*': Multiply;
	'/': Divide;
	else Expected('Mulop');
	end;
  end;
end;

{ Initialize }

procedure Init;
begin
	GetChar;
end;

{ Main Program }

begin
	Init;
	Expression;
end.

