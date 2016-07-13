unit Unt_SplashScreen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Imaging.jpeg,IniFiles;

type
  TFrm_Splash = class(TForm)
    Label1: TLabel;
    PG: TProgressBar;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Splash: TFrm_Splash;

implementation

{$R *.dfm}

uses Unt_Mysql, Unt_Postgres;

end.
