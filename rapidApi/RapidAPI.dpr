program RapidAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  System.JSON,
  System.JSON.Types,
  RESTRequest4D;

var response : IResponse ;
 id , search: string;
 js: TJSONObject;
const
 api_key = '05186ee5c233bfce54a93232dbb46a9e';
 baseurl = 'http://api.scraperapi.com?api_key='+api_key+'&autoparse=true';


begin
  ReportMemoryLeaksOnShutdown := True;
  THorse.Use(Jhonson());
  THorse.Use(CORS);
  // product by id
  THorse.Get('/product/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
    id := req.Params.Items['id'];
    response := RESTRequest4D.TRequest.New
                .BaseURL(baseurl+'&url=https://www.amazon.com/dp/'+id)
                .Get;
      try
       Res.Send(response.Content).ContentType('application/json');
       except on E: Exception do
       Res.Send(e.Message);
      end;
    end);
   // product by search
  THorse.Get('/search/:search',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
    search := req.Params.Items['search'];
    response := RESTRequest4D.TRequest.New
                .BaseURL(baseurl+'&url=https://www.amazon.com/s?k='+search)
                .Get;
      try
       Res.Send(response.Content).ContentType('application/json');
       except on E: Exception do
       Res.Send(e.Message);
      end;
    end);


  THorse.Listen(8080, procedure(Horse: THorse)
    begin
    Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
    end);
end.
