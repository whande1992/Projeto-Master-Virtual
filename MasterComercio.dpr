program MasterComercio;

uses
  Vcl.Forms,
  Unt_Principal in 'Unt_Principal.pas' {Frm_Principal},
  Unt_Exporta_Registros in 'Unt_Exporta_Registros.pas' {frm_Exporta_Registros},
  Unt_Postgres in 'Unt_Postgres.pas' {Data_Postgres: TDataModule},
  Unt_Mysql in 'Unt_Mysql.pas' {Data_Mysql: TDataModule},
  Unt_Thread_comunicador in 'Unt_Thread_comunicador.pas',
  Unt_Configuracoes in 'Unt_Configuracoes.pas' {Frm_Config},
  Unt_SplashScreen in 'Unt_SplashScreen.pas' {Frm_Splash},
  Vcl.Themes,
  Vcl.Styles,
  Unt_Thread_pedidos in 'Unt_Thread_pedidos.pas',
  CadastroSerialPhp in 'CadastroSerialPhp.pas',
  EnderecoSerialPhp in 'EnderecoSerialPhp.pas',
  Unt_Funcoes in 'Unt_Funcoes.pas',
  Unt_Thread_Dupluicatas in 'Unt_Thread_Dupluicatas.pas',
  Unt_Funcoes_ini in 'Unt_Funcoes_ini.pas';

{$R *.res}
VAR
inc:integer;



begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //criando o formulario de splash
  Frm_Splash:= TFrm_Splash.Create(Application);
  Frm_Splash.Show;
  Frm_Splash.Update;


  //incrementando a posicao do progress bar
  Frm_Splash.PG.Visible:=true;
  for inc := 0 to 30000 do
  begin

     Frm_Splash.PG.Position:=inc;
  end;

  Application.MainFormOnTaskbar := False;

  //Cria o formulario principal


  //esconde e libera o splash da memoria

  TStyleManager.TrySetStyle('Windows10 Blue');
  Application.Title := 'Master Virtual';
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.CreateForm(Tfrm_Exporta_Registros, frm_Exporta_Registros);
  Application.CreateForm(TData_Postgres, Data_Postgres);
  Application.CreateForm(TData_Mysql, Data_Mysql);
  Application.CreateForm(TFrm_Config, Frm_Config);
  //Application.CreateForm(TFrm_Splash, Frm_Splash);
  Frm_Splash.Hide;
  Frm_Splash.Free;
  Frm_Splash.Close;
  Application.Run;

end.
