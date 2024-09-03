DO BEGIN

DECLARE Tabela NVARCHAR(4);
DECLARE ObjType NVARCHAR(50);
DECLARE DocEntry NVARCHAR(50);
DECLARE query NVARCHAR(1000000);
DECLARE Consulta NVARCHAR(1000000);


ObjType := 17; --{?ObjectID@};
DocEntry := 42627; --{?DocKey@};

SELECT 
	CASE :ObjType 
		WHEN 13 THEN 'INV' WHEN 14 THEN 'RIN' WHEN 15 THEN 'DLN' 
		WHEN 16 THEN 'RDN' WHEN 17 THEN 'RDR' WHEN 18 THEN 'PCH' 
		WHEN 19 THEN 'RPC' WHEN 20 THEN 'PDN' WHEN 21 THEN 'RPD' 
		WHEN 22 THEN 'POR' WHEN 540000006 THEN 'PQT' WHEN 23 THEN 'QUT' 
		WHEN 203 THEN 'DPI' WHEN 204 THEN 'DPO' WHEN 1470000113 THEN 'PRQ' END
INTO Tabela

FROM
	DUMMY; 



query := '
SELECT DISTINCT

-- DADOS DA EMPRESA 

IFNULL(T9."BPLName",(SELECT "CompnyName" FROM OADM T12 )) as "Empresa",
	IFNULL(nullif(T9."AddrType"||'' ''||T9."Street",''''),(SELECT T12."AddrType"||'' ''||T12."Street" FROM ADM1 T12 )) as "Rua Empresa",
	IFNULL(T9."StreetNo",(SELECT T12."StreetNo" FROM ADM1 T12 )) as "Numero Empresa",
	IFNULL(T9."Building",(SELECT T12."Building" FROM ADM1 T12 )) as "Complemento Empresa",
	IFNULL(T9."City",(SELECT T12."City" FROM ADM1 T12 )) as "Cidade Empresa",
	IFNULL(T9."Block",(SELECT T12."Block" FROM ADM1 T12 )) as "Bairro Empresa",
	IFNULL(T9."State",(SELECT T12."State" FROM ADM1 T12 )) as "UF da Empresa",
	IFNULL(T9."TaxIdNum",(SELECT T12."TaxIdNum" FROM OADM T12 )) as "CNPJ Empresa",
	IFNULL(T9."TaxIdNum2",(SELECT T12."TaxIdNum2" FROM OADM T12 )) as "I.E Empresa",
	(SELECT CAST("E_Mail" AS VARCHAR(10000)) From OADM ) as "Email Empresa",
	(SELECT "Phone1" From OADM ) as "Telefone Empresa",
	(SELECT "Fax" From OADM ) as "Fax da Empresa",
	IFNULL(T9."ZipCode",(SELECT T12."ZipCode" FROM ADM1 T12 )) as "Cep da Empresa",
	(SELECT CAST("IntrntAdrs" AS VARCHAR(10000)) From ADM1 ) as "Site da Empresa",
	(SELECT CAST("BitmapPath" AS VARCHAR(10000))||"LogoFile" from OADP) as "LogoTipo",
	
-- DADOS DO CLIENTE

	T3."CardCode" as "Cod Cliente",
	T3."CardName" as "Nome do Cliente", 
	T3."MailBlock" as "País Cliente", 
	T3."IntrntSite" as "Site Cliente", 
	T3."E_Mail" as "Email Cliente", 
	(IFNULL(T2."AddrTypeS",'''') || '' '' || IFNULL(T2."StreetS",'''') || '' '' ||'', ''|| IFNULL(T2."StreetNoS",'''')  || '' - '' || cast(IFNULL(T2."BuildingS",'''') as nvarchar(15))||'' CEP ''|| IFNULL(T2."ZipCodeS",'''')) as "Endereco Cliente S",
	(IFNULL(T2."AddrTypeB",'''') || '' '' || IFNULL(T2."StreetB",'''') || '' '' ||'', ''|| IFNULL(T2."StreetNoB",'''')  || '' - '' || cast(IFNULL(T2."BuildingB",'''') as nvarchar(15))||'' CEP ''|| IFNULL(T2."ZipCodeB",'''')) as "Endereco Cliente B",
	T4."TaxId0" as "CNPJCliente",
	T4."TaxId1" as "IECliente",
	T6."CntctCode" as "CntctCode",
	T2."StateS" as "StateS",
	T2."StateB" as "StateB",
	T2."CityS" as "CityS",
	T2."CityB" as "CityB",
	T3."Address" as "MailAddres",
	T3."ZipCode" as "MailZipCod",
	T3."Phone2" as "Phone2",
	T3."Phone1" as "Phone1", 
	T3."Fax" as "Fax",
	IFNULL(T6."FirstName",'''')||'' ''||IFNULL(T6."MiddleName",'''')||'' ''||IFNULL(T6."LastName",'''') as "Contato",
	T6."Name" as "ID Contato",
	T6."Tel1" as "Tel1",
	T6."Tel2" as "Tel2",
	T6."E_MailL" as "EmailContato", 

	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''II'')),0) as "II",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''COFINS'') ),0) as "COFINS",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''PIS'' )),0) as "PIS",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ISS'' )),0) as "ISS",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ICMS'' )),0) as "ICMS",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ICMS-ST'')),0) as "ICMS-ST",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''IPI'')),0) as "IPI",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ICMS Dif'')),0) as "ICMS Dif",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''INSS'')),0) as "INSS",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''PIS-ST'')),0) as "PIS-ST",
	IFNULL((SELECT case when T00."TaxSum">0 then T00."TaxSum" else ((T00."TaxRate"*T1."LineTotal")/100) end  FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''COFINS-ST'')),0) as "COFINS-ST",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''II'')),0) as "II Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''COFINS'')),0) as "COFINS Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''PIS'' )),0) as "PIS Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ISS'' )),0) as "ISS Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ICMS'' )),0) as "ICMS Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ICMS-ST'')),0) as "ICMS-ST Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''IPI'')),0) as "IPI Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''ICMS Dif'')),0) as "ICMS Dif Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''INSS'')),0) as "INSS Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''PIS-ST'')),0) as "PIS-ST Aliq",
	IFNULL((SELECT T00."TaxRate" FROM #TABELAVAR#4 T00 INNER JOIN OSTA T01 ON T00."StaCode" = T01."Code" INNER JOIN OSTT T02 ON T01."Type" = T02."AbsId" INNER JOIN ONFT T03 ON T02."NfTaxId" = T03."AbsId" WHERE T1."DocEntry" = T00."DocEntry" AND T1."LineNum" = T00."LineNum" AND T1."TaxOnly" = ''N'' AND T01."Exempt" = ''N'' AND (T03."Code" = ''COFINS-ST'')),0) as "COFINS-ST Aliq",

	T0."ObjType" as "ObjType",
	CASE T0."ObjType" WHEN 13 THEN ''INV'' WHEN 14 THEN ''RIN'' WHEN 15 THEN ''DLN'' WHEN 16 THEN ''RDN'' WHEN 17 THEN ''RDR'' WHEN 18 THEN ''PCH'' WHEN 19 THEN ''RPC'' WHEN 20 THEN ''PDN'' WHEN 21 THEN ''RPD'' WHEN 22 THEN ''POR'' WHEN 540000006 THEN ''PQT'' WHEN 23 THEN ''QUT'' WHEN 203 THEN ''DPI'' WHEN 204 THEN ''DPO'' WHEN 1470000113 THEN ''PRQ'' end as "tabela",
	(SELECT CAST("BitmapPath" as varchar(1000))||CAST("LogoFile" AS varchar(1000)) FROM OADP) as "LOGO",
	T0."DocEntry" as "DocEntry",
	T0."DocNum" as "DocNum",
	CAST(CAST(T0."Comments" AS VARCHAR(10000)) AS NVARCHAR(10000)) as "Comentarios Doc",
	T0."NumAtCard" as "NumProcesso",
	T0."DocDueDate" as "Data Entrega",
	T0."TaxDate" as "Data do Documento",
	T0."CreateDate" as "Data Criação Doc",
	T0."SlpCode" as "CodVendedor",
	(select T10."SlpName" from OSLP T10 where T10."SlpCode"=T0."SlpCode") as "nomeVendedor",
	(select IFNULL(ta."firstName",'''') || '' '' || IFNULL(ta."middleName",'''') || '' '' || IFNULL(ta."lastName",'''') from OHEM ta where ta."empID" = t0."OwnerCode") as "nome titular",
	T0."Weight" as "PesoTotal",
	(case when T1."Currency" != ''R$''  then T0."VatSumFC" else T0."VatSum" end) as "Impostos",
	((case when T1."Currency" != ''R$'' then T0."DocTotalFC" else T0."DocTotal" end) - (case when T1."Currency" != ''R$'' then T0."VatSumFC" else T0."VatSum" end)) as "Total Mercadoria",
	(case when T1."Currency" != ''R$''  then T0."DocTotalFC" else T0."DocTotal" end) as "DocTotal",
	
	T8."NcmCode" as "NcmCode",
	T7."PymntGroup" as "Shipping Method",
	(SELECT MAX(1+m."LogInstanc") from ADOC M where M."DocNum"=T0."DocNum" and M."ObjType"=T0."ObjType" and M."CardCode"=T0."CardCode") as "log de modificações",
	(SELECT "NetWeight" from #TABELAVAR#12 x where x."DocEntry" = T0."DocEntry") as "NetWeight",
	(SELECT "TrnspName" from OSHP where OSHP."TrnspCode" = T0."TrnspCode" ) as "TipoEnvio",
	IFNULL((SELECT sum(T10."LineTotal") from  #TABELAVAR#3 T10 left join OEXD T11 on  T10."ExpnsCode"=T11."ExpnsCode" WHERE T10."DocEntry"=T0."DocEntry" AND T11."ExpnsType"=1 ),0) as "ValorFrete",
	T2."Carrier" as "Transportadora",
	CASE T2."Incoterms" WHEN ''0'' THEN ''CIF - Por conta do emitente'' WHEN ''1'' THEN ''FOB - Por conta do destinatário/remetente'' WHEN ''2'' THEN ''TER - Por conta de terceiros'' WHEN ''9'' THEN ''SEM - Sem frete'' else ''Outros'' END Incoterms, 
	(SELECT T00."CardName" from OCRD T00 where T00."CardCode"=T2."Carrier" ) as "Nome Transportadora",
	(SELECT ("AddrType"||'' ''||"Street") from CRD1 where CRD1."CardCode"=T2."Carrier" and "AdresType"=''S'' ) as "Rua Transp",
	(SELECT "StreetNo" from CRD1 where CRD1."CardCode"=T2."Carrier" and "AdresType"=''S'' ) as "Num Transp",
	(SELECT CAST("Building" AS VARCHAR(10000)) from CRD1 where CRD1."CardCode"=T2."Carrier" and "AdresType"=''S'' ) as "Comp Transp",
	(SELECT "Block" from CRD1 where CRD1."CardCode"=T2."Carrier" and "AdresType"=''S'' ) as "Bairro Transp",
	(SELECT "ZipCode" from CRD1 where CRD1."CardCode"=T2."Carrier" and "AdresType"=''S'' ) as "CEP Transp",
	(SELECT "City" from CRD1 where CRD1."CardCode"=T2."Carrier" and "AdresType"=''S'' ) as "Cidade Transp",
	(SELECT "State" from CRD1 where CRD1."CardCode"=T2."Carrier" and "AdresType"=''S'' ) as "UF Transp",
	(SELECT CAST("E_Mail" AS VARCHAR(1000)) from OCRD where OCRD."CardCode"=T2."Carrier" ) as "Email Transp",
	(SELECT "Fax" from OCRD where OCRD."CardCode"=T2."Carrier" ) as "Fax Transp",
	(SELECT (''(''||CAST("Phone2" AS VARCHAR(10000))||'')'' ||CAST("Phone1" AS VARCHAR(10000))) from OCRD where OCRD."CardCode"=T2."Carrier" ) as "Telefone Transp",
	(SELECT CAST(T00."CardName" AS VARCHAR(10000)) from OCRD T00 inner join OCPR T01 on T01."CardCode"=T00."CardCode" where T00."CardCode"=T2."Carrier" and T00."CntctPrsn"=T01."Name" ) as "Contato Transp",
	T1."ItemCode" as "Cod Item",
	T1."LineNum" as "Nº Linha",
	T1."Dscription" as "Desc Item", 
	T1."Quantity" as "Quantidade de Itens",
	T1."ShipDate" as "Data Entrega Linha",
	T1."Price" as "Preço Unit Item",
	T1."unitMsr" as "UN",
	T1."VisOrder" as "VisOrder",
	T1."Currency" as "Currency",
	T1."Weight1" as "PesoLinhaItem",
	(case when T1."Currency" != ''R$'' then T1."TotalFrgn" else T1."LineTotal" end) as "Total Linha", 
	(case when CAST(T1."VendorNum" AS VARCHAR(10000)) is null then T1."ItemCode" when T1."VendorNum" = '''' then T1."ItemCode" else T1."VendorNum" end) as "CodFabricante",
	
	T0."DocDate", 
	T10."PymntGroup", 
	T1."DiscPrcnt", 
	T1."PriceBefDi"

FROM 
	O#TABELAVAR# T0 INNER JOIN #TABELAVAR#1 T1 on T0."DocEntry" = T1."DocEntry"
	LEFT  JOIN #TABELAVAR#12 T2 on T2."DocEntry" = T0."DocEntry" 
	LEFT JOIN OCRD T3 ON T0."CardCode"=T3."CardCode" 
	LEFT  JOIN CRD7 T4 on (T4."CardCode"=T0."CardCode" and T4."CardCode"= T3."CardCode" and T4."Address" ='''')
	LEFT  JOIN OITM T5 ON T5."ItemCode" = T1."ItemCode" 
	LEFT  JOIN OCPR T6 on T6."Name" = T3."CntctPrsn" and T6."CardCode"=T0."CardCode" 
	LEFT  JOIN OCTG T7 on T7."GroupNum" = T0."GroupNum" 
	LEFT  JOIN ONCM T8 on T5."NCMCode" = T8."AbsEntry"
	LEFT  JOIN OBPL T9 on T9."BPLId" = t0."BPLId"
	LEFT  JOIN OCTG T10 on T10."GroupNum" = T0."GroupNum"

WHERE 
	T0."DocEntry"=#DOCENTRY#
';



Consulta := REPLACE(REPLACE(:query,'#TABELAVAR#',:Tabela),'#DOCENTRY#',:DocEntry) ;



EXECUTE IMMEDIATE Consulta;


END