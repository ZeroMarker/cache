
var VendorExcelData="";
var ManfExcelData="";

function previewData(fileName)
{	
				 					
	var cmVen=new Ext.grid.ColumnModel(
		[{header:'����',dataIndex:'Code'},
		{header:'����',dataIndex:'Name'},
		{header:'�绰',dataIndex:'Tel'},		
		{header:'��������',dataIndex:'ConPerson'},	
		{header:'�����˺�',dataIndex:'CtrlAcct'},		
		{header:'�ɹ��޶�',dataIndex:'CrLimit'},
		{header:'��Ӧ�̷���',dataIndex:'CategoryId'},
		{header:'��ͬ��ֹ����',dataIndex:'LstPoDate'},		
		{header:'����',dataIndex:'Fax'},
		{header:'���˴���',dataIndex:'President'},
		{header:'���˴���Id',dataIndex:'PresidentId',hidden:true},	
		{header:'��Ӧ��״̬',dataIndex:'Status',hidden:true},
		{header:'ע���ʽ�',dataIndex:'CrAvail',hidden:true},		
		{header:'��ַ',dataIndex:'Address'},
		{header:'RCFlag',dataIndex:'RCFlag',hidden:true},
		{header:'����ִ��',dataIndex:'ComLic'},
		{header:'����ִ��-��Ч��',dataIndex:'ComLicDate'},
		{header:'˰��Ǽ�',dataIndex:'RevReg'},
		{header:'˰��Ǽ�-Ч��',dataIndex:'RevRegDate'},
		{header:'ҽ����е��Ӫ���֤',dataIndex:'MatManLic'},
		{header:'ҽ����е��Ӫ���֤-Ч��',dataIndex:'MatManLicDate'},
		{header:'ҽ����еע��֤',dataIndex:'MatEnrol'},
		{header:'ҽ����еע��֤-Ч��',dataIndex:'MatEnrolDate'},
		{header:'�������֤',dataIndex:'Sanitation'},
		{header:'�������֤-Ч��',dataIndex:'SanitationDate'},
		{header:'��֯��������',dataIndex:'OrgCode'},
		{header:'��֯��������-Ч��',dataIndex:'OrgCodeDate'},
		{header:'Gsp',dataIndex:'Gsp'},
		{header:'GspЧ��',dataIndex:'GspDate'},
		{header:'��е�������֤',dataIndex:'MatPro'},
		{header:'��е�������֤-Ч��',dataIndex:'MatProDate'},	
		{header:'���������Ͽɱ�',dataIndex:'ProPermit'},
		{header:'���������Ͽɱ�-Ч��',dataIndex:'ProPermitDate'},		
		{header:'����ҽ����еע��֤',dataIndex:'ImportEnrol'},
		{header:'����ҽ����еע��֤-Ч��',dataIndex:'ImportEnrolDate'},
		{header:'����ע��ǼǱ�',dataIndex:'ImportLic'},
		{header:'����ע��ǼǱ�-Ч��',dataIndex:'ImportLicDate'},		
		{header:'����������Ȩ��',dataIndex:'AgentLic'},
		{header:'����������Ȩ��-Ч��',dataIndex:'AgentLicDate'},
		{header:'',dataIndex:'DrugManLic',hidden:true},
		{header:'',dataIndex:'DrugManLicDate',hidden:true},
		{header:'�ۺ�����ŵ��',dataIndex:'Promises'},
		{header:'����ί����',dataIndex:'TrustDeed'},
		{header:'������ŵ��',dataIndex:'Quality'},
		{header:'������ŵ��-��Ч��',dataIndex:'QualityDate'},
		{header:'ҵ��Ա����',dataIndex:'SalesName'},
		{header:'ҵ��Ա��Ȩ��-��Ч��',dataIndex:'SalesNameDate'},
		{header:'ҵ��Ա�绰',dataIndex:'SalesTel'}]
		) ;
		

	var venRec = Ext.data.Record.create([
	    {name: 'Code'},
	    {name: 'Name'},
	    {name:'Tel'},
	    {name:'ConPerson'},
	    {name:'CtrlAcct'},
	    {name:'CrLimit'},
	    {name:'Fax'},
	    {name:'President'},
	    {name:'PresidentId'},
	    {name:'Status'},
	    {name:'CategoryId'},
	    {name:'CrAvail'},
	    {name:'LstPoDate'},
	    {name:'Address'},
	    {name:'RCFlag'},
	    {name:'ComLic'},
	    {name:'ComLicDate'},
	    {name:'AgentLic'},
	    {name:'DrugManLic'},
	    {name:'DrugManLicDate'},
	    {name:'Gsp'},
	    {name:'GspDate'},
	    {name:'ImportEnrol'},
	    {name:'ImportEnrolDate'},
		{name:'ImportLic'},
		{name:'ImportLicDate'},
		{name:'MatEnrol'},
		{name:'MatEnrolDate'},
		{name:'MatManLic'},
		{name:'MatManLicDate'},																			
		{name:'MatPro'},
		{name:'MatProDate'},
		{name:'OrgCode'},
		{name:'OrgCodeDate'},
		{name:'Promises'},
		{name:'ProPermit'},
		{name:'ProPermitDate'},
		{name:'RevReg'},
		{name:'RevRegDate'},
		{name:'Sanitation'},
		{name:'SanitationDate'},
		{name:'TrustDeed'},
		{name:'Quality'},
		{name:'QualityDate'},
		{name:'AgentLicDate'},
		{name:'SalesName'},
		{name:'SalesNameDate'},
		{name:'SalesTel'}
	]);
		
	var manfRec = Ext.data.Record.create([
	    {name: 'Code'},
	    {name: 'Name'},
	    {name:'Address'},	    
	    {name:'Tel'},
	    {name:'ParManfId'},
	    {name:'DrugPermit'},
	    {name:'DrugPermitExp'},
	    {name:'MatPermit'},
	    {name:'MatPermitExp'},
	    {name:'ComLic'},
	    {name:'ComLicExp'},
	    {name:'Active'},
	    {name:'BusinessRegNo'},
	    {name:'BusinessRegExpDate'},
	    {name:'OrgCode'},
	    {name:'OrgCodeExpDate'},
	    {name:'TaxRegNo'},
	    {name:'MatManLic'},
	    {name:'MatManLicDate'}
	]);
	
					
	var reader =  new Ext.data.ArrayReader(
	        {
	            idIndex: 0  // id for each record will be the first element
	        },
	        venRec // recordType
	    );

	var reader2 =  new Ext.data.ArrayReader(
	        {
	            idIndex: 0  // id for each record will be the first element
	        },
	        manfRec // recordType
	    );		
	    
	
	var store1=new Ext.data.Store({
		reader:reader
	});
		
	var store2=new Ext.data.Store({
		reader:reader2
	});
		
	
	var gridVendor=new Ext.grid.GridPanel({
		title:'��Ӧ����Ϣ',
		cm:cmVen,
		height:200,
		region:'north',
	    store:store1
		});
		
	var cmManf = new Ext.grid.ColumnModel([
	{	header:'����',dataIndex: 'Code'},
	    {header:'����',dataIndex: 'Name'},    
	    {header:'��ַ',dataIndex:'Address'},	    
	    {header:'�绰',dataIndex:'Tel'},
	    {header:'�ϼ�����',dataIndex:'ParManfId'},
	    {header:'ҩ���������֤',dataIndex:'DrugPermit'},
	    {header:'ҩ���������֤Ч��',dataIndex:'DrugPermitExp'},   
	    {header:'�����������֤',dataIndex:'MatPermit'},
	    {header:'�����������֤Ч��',dataIndex:'MatPermitExp'},
	    {header:'����ִ�����',dataIndex:'ComLic'},
	    {header:'����ִ�����Ч��',dataIndex:'ComLicExp'},
	    {header:'Active',dataIndex:'Active',hidden:true},
	    {header:'����ע���',dataIndex:'BusinessRegNo'},
	    {header:'����ע���Ч��',dataIndex:'BusinessRegExpDate'},
	    {header:'��֯��������',dataIndex:'OrgCode'},
	    {header:'��֯��������Ч��',dataIndex:'OrgCodeExpDate'},
	    {header:'˰��ǼǺ�',dataIndex:'TaxRegNo'},
	    {header:'��е��Ӫ���֤',dataIndex:'MatManLic'},
	    {header:'��е��Ӫ���֤Ч��',dataIndex:'MatManLicDate'}
	]);	  		
		    
	var gridManf=new Ext.grid.GridPanel({
		title:'������Ϣ',
		cm:cmManf,
		store:store2,
		region:'center'
	
	})
 	
	var t1=new Ext.Toolbar.Button({
		text:'ִ�и���',
		iconCls:'page_edit',
		id:'update',
		handler:function()
		{
//			alert(VendorExcelData);
//			alert(ManfExcelData);
			if (VendorExcelData!='')
			{
				UpdVendor(VendorExcelData);
			}
			
			if (ManfExcelData!='')
			{
				UpdManf(ManfExcelData);
			}			
		}
	});
	var t2=new Ext.Toolbar.Button({
		text:'ȡ��',
		id:'cacelBt',
		iconCls:'page_edit',
		handler:function()
		{
			win.close();
		}
	});
	
	var win=new Ext.Window({
		title:'��Ӧ�������Ϣ��������',
		width:800,
		height:500,
		tbar:[t1,'-',t2],
		layout:'border'	,
		items:[gridVendor,gridManf],
		listeners:{
			'show':function()
			{					
				ReadFromExcel(fileName);
			},
			'beforeshow':function()
			{
				if (fileName=='') 
				{
					Msg.info('error','��ѡ��Excel�ļ�!');
					return false;			
				}
			}
		}
	});

	win.show();

	/*��ȡ��Ӧ������*/
	function ReadFromExcel(fileName)
	{
		var Template=fileName;
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);	
		var xlsheetVendor = xlBook.Worksheets(1) ;	//���¹�Ӧ��
		var xlsheetManf = xlBook.Worksheets(2) ;	 //���³���
		
		if (xlApp)	{ReadVendorFromExcel(xlApp,xlBook,xlsheetVendor,xlsheetManf); }
		
	}
	
	 function ReadVendorFromExcel(xlApp,xlBook,xlsheet,xlsheet2)
	 {
	 	
	 	VendorExcelData="";
	 	ManfExcelData="";
	 	
	 	var startRow=2;
	 	var myData = [];
		try{
			for (var i=startRow;i<startRow+1;i++)
			{
				var code=vStr(xlsheet.Cells(i,1).value);	//��Ӧ�̴���
				if (code==""){Msg.info("error","��Ӧ�̴��벻��Ϊ��,�����ļ�!!");Ext.getCmp("update").setDisabled(true);}
				var name=vStr(xlsheet.Cells(i,2).value);	//��Ӧ������
				if (name==""){Msg.info("error","��Ӧ�����Ʋ���Ϊ��,�����ļ�!!");Ext.getCmp("update").setDisabled(true);}
				var tel	=vStr(xlsheet.Cells(i,3).value);	//��Ӧ�̵绰
				var contact	=vStr(xlsheet.Cells(i,4).value);	//������
				var account	=vStr(xlsheet.Cells(i,5).value);	//�˺�
				var purchaseAmtLtd	=vStr(xlsheet.Cells(i,6).value);	//�ɹ��޶�
				var cats=vStr(xlsheet.Cells(i,7).value);	//��Ӧ�̷���
				var contractenddate	=vDate(xlsheet.Cells(i,8).value);	//��ͬ��ֹ����
//				alert(contractenddate)
				var fax	=vStr(xlsheet.Cells(i,9).value);	//����
				var legal_representative	=vStr(xlsheet.Cells(i,10).value);	//���˴���
				var address	=vStr(xlsheet.Cells(i,11).value);	//��ַ
				var comLic	=vStr(xlsheet.Cells(i,12).value);//	����ִ��
				var comLic_ExpDate	=vDate(xlsheet.Cells(i,13).value);	//����ִ����Ч��
				var taxLic	=vStr(xlsheet.Cells(i,14).value);	//˰��Ǽ�
				var taxLic_ExpDate	=vDate(xlsheet.Cells(i,15).value);	//˰��Ǽ�Ч��
				var insBusLic=vStr(xlsheet.Cells(i,16).value);//	ҽ����е��Ӫ���֤
				var insBusLic_ExpDate=vDate(xlsheet.Cells(i,17).value);	//Ч��
				
				var proPermit=vStr(xlsheet.Cells(i,18).value);  //���������Ͽɱ�	
				var proPermit_ExpDate=vDate(xlsheet.Cells(i,19).value);  //Ч��	 
				
				var insRegLic	=vStr(xlsheet.Cells(i,20).value);	//ҽ����еע��֤
				var insRegLic_ExpDate=vDate(xlsheet.Cells(i,21).value);	//	Ч��
				var hygLic=vStr(xlsheet.Cells(i,22).value);	//	�������֤
				var hygLic_ExpDate=vDate(xlsheet.Cells(i,23).value);		//Ч��
				var orgCode	=vStr(xlsheet.Cells(i,24).value);	//��֯��������
				var orgCode_ExpDate	=vDate(xlsheet.Cells(i,25).value);	//Ч��
				var Gsp	=vStr(xlsheet.Cells(i,26).value);	//Gsp
				var Gsp_ExpDate	=vDate(xlsheet.Cells(i,27).value);	//GspЧ��
				var insProLic=vStr(xlsheet.Cells(i,28).value);	//	��е�������֤
				var insProLic_ExpDate=vDate(xlsheet.Cells(i,29).value);	//	Ч��		
				var inletRLic	=vStr(xlsheet.Cells(i,30).value);	//����ҽ����еע��֤
				var inletRLic_ExpDate=vDate(xlsheet.Cells(i,31).value);//	Ч��	
				var inletRegLic	=vStr(xlsheet.Cells(i,32).value);	//����ע��ǼǱ�
				var inletRegLic_ExpDate	=vDate(xlsheet.Cells(i,33).value);//	Ч��
				var agentAuth	=vStr(xlsheet.Cells(i,34).value);	//����������Ȩ��
				var agentAuth_ExpDate=vDate(xlsheet.Cells(i,35).value);	//	Ч��
				var serviceComm	=vStr(xlsheet.Cells(i,36).value);//�ۺ�����ŵ��
				var legalComm	=vStr(xlsheet.Cells(i,37).value);	//	����ί����
				var qualityComm	=vStr(xlsheet.Cells(i,38).value);//������ŵ��
				var qualityComm_ExpDate	=vDate(xlsheet.Cells(i,39).value);	//������ŵ����Ч��
				var salesmanName	=vStr(xlsheet.Cells(i,40).value);	//ҵ��Ա����
				var salesmanAuth_ExpDate	=vDate(xlsheet.Cells(i,41).value);//	ҵ��Ա��Ȩ����Ч��
				var salesmanTel=vStr(xlsheet.Cells(i,42).value);	//ҵ��Ա�绰
				
				var result_str="";
				var Code=code;   //(1)
				var Name=name;  //(2)
				var Tel=tel;  //(3)
				var ConPerson=contact;//(4)
				var CtrlAcct=account ;//(5)
				var CrLimit= purchaseAmtLtd ;//(6)		
				var Fax=fax ; //(7)
				var President= legal_representative ;//(8) -���˴���
				var PresidentId="";	//(9)  -���˴������֤��
				var Status="" ;//(10)
				result_str=Code+"^"+Name+"^"+Tel+"^"+ConPerson+"^"+CtrlAcct+"^"+CrLimit+"^"+Fax+"^"+President+"^"+PresidentId+"^"+Status;
				var CategoryId=cats ;//(11)
				
				var CrAvail="" ;  //(12)  -ע���ʽ�
				var LstPoDate=contractenddate ; //(13)  -��ͬ��������
				var Address=address;  //(14)
				var RCFlag="";  //(15)
				var ComLic=comLic  ;//(16)
				var ComLicDate=comLic_ExpDate ; //(17)
				var AgentLic=agentAuth ; //(18)
				var DrugManLic="" ; //(19)   ҩƷ��Ӫ���֤
				var DrugManLicDate="" ;  //(20) ҩƷ��Ӫ���֤Ч��
				result_str=result_str+"^"+CategoryId+"^"+CrAvail+"^"+LstPoDate+"^"+Address+"^"+RCFlag+"^"+ComLic+"^"+ComLicDate+"^"+AgentLic+"^"+DrugManLic+"^"+DrugManLicDate;
				var Gsp=Gsp;  // (21)
				var GspDate=Gsp_ExpDate ; //(22)	
				var ImportEnrol=inletRLic ; //(23)
				var ImportEnrolDate=inletRLic_ExpDate;  //(24)
				var ImportLic=inletRegLic;//(25)
				var ImportLicDate=inletRegLic_ExpDate ;//(26)
				var MatEnrol=insRegLic  ; //(27)   - ҽ����еע��֤
				var MatEnrolDate=insRegLic_ExpDate ;   //(28)
				var MatManLic=insBusLic ;//(29)  - ҽ����е��Ӫ���֤
				var MatManLicDate=insBusLic_ExpDate; //(30)		
				result_str=result_str+"^"+Gsp+"^"+GspDate+"^"+ImportEnrol+"^"+ImportEnrolDate+"^"+ImportLic+"^"+ImportLicDate+"^"+MatEnrol+"^"+MatEnrolDate+"^"+MatManLic+"^"+MatManLicDate;
				var MatPro=insProLic;  //(31) - ��е�������֤
				var MatProDate=insProLic_ExpDate ; //(32)
				var OrgCode=orgCode ; // (33)
				var OrgCodeDate=orgCode_ExpDate;  // (34)	
				var Promises=serviceComm;  //(35)  - �ۺ�����ŵ��
				var ProPermit=proPermit ;//(36)   - ����������ɱ�
				var ProPermitDate=proPermit_ExpDate;   //(37)
				var RevReg=taxLic;   //(38) -˰��ǼǺ�
				var RevRegDate=taxLic_ExpDate ;  //(39)
				var Sanitation=hygLic ; //(40)  -�������֤
				result_str=result_str+"^"+MatPro+"^"+MatProDate+"^"+OrgCode+"^"+OrgCodeDate+"^"+Promises+"^"+ProPermit+"^"+ProPermitDate+"^"+RevReg+"^"+RevRegDate+"^"+Sanitation;
				var SanitationDate=hygLic_ExpDate;//(41)
				var TrustDeed=legalComm;  //(42)  -����ί����
				var Quality=qualityComm ; //(43)
				var QualityDate=qualityComm_ExpDate ; //(44)
				var AgentLicDate=agentAuth_ExpDate ; //(45)  -������Ȩ��Ч��
				var SalesName=salesmanName ; //(46)
				var SalesNameDate=salesmanAuth_ExpDate ; //(47)
				var SalesTel=salesmanTel;  //(48)
				result_str=result_str+"^"+SanitationDate+"^"+TrustDeed+"^"+Quality+"^"+QualityDate+"^"+AgentLicDate+"^"+SalesName+"^"+SalesNameDate+"^"+SalesTel;
	
				VendorExcelData = result_str;		
	  			
	  			var venArr=  [Code,Name,Tel,ConPerson,CtrlAcct,CrLimit,Fax,President,PresidentId,Status,CategoryId,CrAvail,LstPoDate,Address,RCFlag,
				ComLic,ComLicDate,AgentLic,DrugManLic,DrugManLicDate,Gsp,GspDate,ImportEnrol,ImportEnrolDate,ImportLic,ImportLicDate,MatEnrol,
				MatEnrolDate,MatManLic,MatManLicDate,MatPro,MatProDate,OrgCode,OrgCodeDate,Promises,ProPermit,ProPermitDate,RevReg,
				RevRegDate,Sanitation,SanitationDate,TrustDeed,Quality,QualityDate,AgentLicDate,SalesName,SalesNameDate,SalesTel];
	  			
	  			
	  			myData.length=myData.length+1;
				myData[myData.length-1]=venArr;		
				
			}
			
			store1.loadData(myData);
		}
		catch(e)
		{
			alert('��ȡExcel�ļ���Ӧ����Ϣ����:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}
		
		var startRow=2;
		var myData2 = [];
		try{
			for (var i=startRow;i<1000;i++)
			{
				var result_str="";
				
				var Code=vStr(xlsheet2.Cells(i,1).value);
				//if (Code==""){Msg.info("error","���̴��벻��Ϊ��,�����ļ�!");Ext.getCmp("update").setDisabled(true);}
				var Name =vStr(xlsheet2.Cells(i,2).value); 
				//if (Name==""){Msg.info("error","�������Ʋ���Ϊ��,�����ļ�!");Ext.getCmp("update").setDisabled(true);}
				if (Name=='') break;
				var Address	=vStr(xlsheet2.Cells(i,3).value);
				var Tel=vStr(xlsheet2.Cells(i,4).value);
				var ParManfId =vStr(xlsheet2.Cells(i,5).value);
				var DrugPermit	=vStr(xlsheet2.Cells(i,6).value);
				var DrugPermitExp	=vDate(xlsheet2.Cells(i,7).value);
				var MatPermit	=vStr(xlsheet2.Cells(i,8).value);
				var MatPermitExp =vDate(xlsheet2.Cells(i,9).value);
				var ComLic =vStr(xlsheet2.Cells(i,10).value);
				result_str=Code+"^"+Name+"^"+Address+"^"+Tel+"^"+ParManfId+"^"+DrugPermit+"^"+DrugPermitExp+"^"+MatPermit+"^"+MatPermitExp+"^"+ComLic;
				var ComLicExp  =vDate(xlsheet2.Cells(i,11).value);
				var Active="";
				var BusinessRegNo  =vStr(xlsheet2.Cells(i,12).value);
				var BusinessRegExpDate=vDate(xlsheet2.Cells(i,13).value);
				var OrgCode	=vStr(xlsheet2.Cells(i,14).value);
				var OrgCodeExpDate	=vDate(xlsheet2.Cells(i,15).value);
				var TaxRegNo   =vStr(xlsheet2.Cells(i,16).value);
				var MatManLic =vStr(xlsheet2.Cells(i,17).value);
				var MatManLicDate	=vDate(xlsheet2.Cells(i,18).value);
				result_str=result_str+"^"+ComLicExp+"^"+Active+"^"+BusinessRegNo+"^"+BusinessRegExpDate+"^"+OrgCode+"^"+OrgCodeExpDate+"^"+TaxRegNo+"^"+MatManLic+"^"+MatManLicDate;
				
				
				if (ManfExcelData=='')
					{ManfExcelData =result_str;}
				else
					{ManfExcelData =ManfExcelData + xRowDelim()+result_str;}			
				var manfArr=[Code,Name,Address,Tel,ParManfId,DrugPermit,DrugPermitExp,MatPermit,MatPermitExp,ComLic,ComLicExp,Active,BusinessRegNo,BusinessRegExpDate,OrgCode,OrgCodeExpDate,TaxRegNo,MatManLic,MatManLicDate] ;
				myData2.length=myData2.length+1;
				myData2[myData2.length-1]=manfArr;
			}		
			
			store2.loadData(myData2);
		}
		catch(e)
		{
			alert('��ȡExcel�ļ�������Ϣ����:'+e);
			closeFile(xlApp,xlBook,xlsheet2);
		}		
		
		if (xlApp) xlApp=null;
		if (xlsheet) xlsheet=null;
		if (xlsheet2) xlsheet2=null;
		if (xlBook) {xlBook.Close(savechanges=false);}
	 }
	
	function UpdVendor(result_str)
	{
		var url="dhcstm.apcvendoraction.csp?actiontype=UpdVendorFromExcel"+"&VendorInfoStr="+result_str;
		Ext.Ajax.request({
			url:url,
			params:{VendorInfoStr:result_str},
			success:function(result, request)
			{
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					if (name=="") 	{var info='���빩Ӧ��';}
					else  {var info='���¹�Ӧ��';}
					Msg.info('success',info+'�ɹ�!');
//					var rowid = jsonData.info;
//					currVendorRowId=rowid;
//					CreateEditWin();
				}
				else
				{
					Msg.info('error','ʧ��');
				}
			},
			failure: function(result, request) {
				Msg.info('error','ʧ��!');
			},
			callback:function()
			{
	
			}
			 
		});
	}		
	
	function closeFile(xlApp,xlsheet,xlBook)
	{
		if (xlApp) xlApp=null;
		if (xlsheet) xlsheet=null;
		if (xlBook) {xlBook.Close(savechanges=false);}
	}	
		
		
	function UpdManf(result_str)
	{
		var url="dhcstm.apcvendoraction.csp?actiontype=UpdManfFromExcel";
		Ext.Ajax.request({
			url:url,
			params:{ManfInfoStr:result_str},
			success:function(result, request)
			{
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					if (name=="") 	{var info='���볧��';}
					else  {var info='���³���';}
					Msg.info('success',info+'�ɹ�!');
					//var rowid = jsonData.info;
					//CreateEditWin(rowid);
				}
				else
				{
					Msg.info('error','ʧ��');
				}
			},
			failure: function(result, request) {
				Msg.info('error','ʧ��!');
			}
		});
	}

}


function vStr(v)
{
	if  ((v==undefined)||(v==null))
	{ 
		v='';
	}
	return v;
}
function vDate(dd) 
{
	if  ((dd==undefined)||(dd==null))
	{ 
		dd='';
		return dd;
	}
	else
	{
		var d=new Date(dd);
		return d.format(ARG_DATEFORMAT);
	}
}
		