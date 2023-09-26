
var VendorExcelData="";
var ManfExcelData="";

function previewData(fileName)
{	
				 					
	var cmVen=new Ext.grid.ColumnModel(
		[{header:'代码',dataIndex:'Code'},
		{header:'名称',dataIndex:'Name'},
		{header:'电话',dataIndex:'Tel'},		
		{header:'开户银行',dataIndex:'ConPerson'},	
		{header:'开户账号',dataIndex:'CtrlAcct'},		
		{header:'采购限额',dataIndex:'CrLimit'},
		{header:'供应商分类',dataIndex:'CategoryId'},
		{header:'合同截止日期',dataIndex:'LstPoDate'},		
		{header:'传真',dataIndex:'Fax'},
		{header:'法人代表',dataIndex:'President'},
		{header:'法人代表Id',dataIndex:'PresidentId',hidden:true},	
		{header:'供应商状态',dataIndex:'Status',hidden:true},
		{header:'注册资金',dataIndex:'CrAvail',hidden:true},		
		{header:'地址',dataIndex:'Address'},
		{header:'RCFlag',dataIndex:'RCFlag',hidden:true},
		{header:'工商执照',dataIndex:'ComLic'},
		{header:'工商执照-有效期',dataIndex:'ComLicDate'},
		{header:'税务登记',dataIndex:'RevReg'},
		{header:'税务登记-效期',dataIndex:'RevRegDate'},
		{header:'医疗器械经营许可证',dataIndex:'MatManLic'},
		{header:'医疗器械经营许可证-效期',dataIndex:'MatManLicDate'},
		{header:'医疗器械注册证',dataIndex:'MatEnrol'},
		{header:'医疗器械注册证-效期',dataIndex:'MatEnrolDate'},
		{header:'卫生许可证',dataIndex:'Sanitation'},
		{header:'卫生许可证-效期',dataIndex:'SanitationDate'},
		{header:'组织机构代码',dataIndex:'OrgCode'},
		{header:'组织机构代码-效期',dataIndex:'OrgCodeDate'},
		{header:'Gsp',dataIndex:'Gsp'},
		{header:'Gsp效期',dataIndex:'GspDate'},
		{header:'器械生产许可证',dataIndex:'MatPro'},
		{header:'器械生产许可证-效期',dataIndex:'MatProDate'},	
		{header:'生产制造认可表',dataIndex:'ProPermit'},
		{header:'生产制造认可表-效期',dataIndex:'ProPermitDate'},		
		{header:'进口医疗器械注册证',dataIndex:'ImportEnrol'},
		{header:'进口医疗器械注册证-效期',dataIndex:'ImportEnrolDate'},
		{header:'进口注册登记表',dataIndex:'ImportLic'},
		{header:'进口注册登记表-效期',dataIndex:'ImportLicDate'},		
		{header:'代理销售授权书',dataIndex:'AgentLic'},
		{header:'代理销售授权书-效期',dataIndex:'AgentLicDate'},
		{header:'',dataIndex:'DrugManLic',hidden:true},
		{header:'',dataIndex:'DrugManLicDate',hidden:true},
		{header:'售后服务承诺书',dataIndex:'Promises'},
		{header:'法人委托书',dataIndex:'TrustDeed'},
		{header:'质量承诺书',dataIndex:'Quality'},
		{header:'质量承诺书-有效期',dataIndex:'QualityDate'},
		{header:'业务员姓名',dataIndex:'SalesName'},
		{header:'业务员授权书-有效期',dataIndex:'SalesNameDate'},
		{header:'业务员电话',dataIndex:'SalesTel'}]
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
		title:'供应商信息',
		cm:cmVen,
		height:200,
		region:'north',
	    store:store1
		});
		
	var cmManf = new Ext.grid.ColumnModel([
	{	header:'代码',dataIndex: 'Code'},
	    {header:'名称',dataIndex: 'Name'},    
	    {header:'地址',dataIndex:'Address'},	    
	    {header:'电话',dataIndex:'Tel'},
	    {header:'上级厂商',dataIndex:'ParManfId'},
	    {header:'药物生产许可证',dataIndex:'DrugPermit'},
	    {header:'药物生产许可证效期',dataIndex:'DrugPermitExp'},   
	    {header:'材料生产许可证',dataIndex:'MatPermit'},
	    {header:'材料生产许可证效期',dataIndex:'MatPermitExp'},
	    {header:'工商执照许可',dataIndex:'ComLic'},
	    {header:'工商执照许可效期',dataIndex:'ComLicExp'},
	    {header:'Active',dataIndex:'Active',hidden:true},
	    {header:'工商注册号',dataIndex:'BusinessRegNo'},
	    {header:'工商注册号效期',dataIndex:'BusinessRegExpDate'},
	    {header:'组织机构代码',dataIndex:'OrgCode'},
	    {header:'组织机构代码效期',dataIndex:'OrgCodeExpDate'},
	    {header:'税务登记号',dataIndex:'TaxRegNo'},
	    {header:'器械经营许可证',dataIndex:'MatManLic'},
	    {header:'器械经营许可证效期',dataIndex:'MatManLicDate'}
	]);	  		
		    
	var gridManf=new Ext.grid.GridPanel({
		title:'厂商信息',
		cm:cmManf,
		store:store2,
		region:'center'
	
	})
 	
	var t1=new Ext.Toolbar.Button({
		text:'执行更新',
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
		text:'取消',
		id:'cacelBt',
		iconCls:'page_edit',
		handler:function()
		{
			win.close();
		}
	});
	
	var win=new Ext.Window({
		title:'供应商相关信息批量更新',
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
					Msg.info('error','请选择Excel文件!');
					return false;			
				}
			}
		}
	});

	win.show();

	/*读取供应商数据*/
	function ReadFromExcel(fileName)
	{
		var Template=fileName;
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);	
		var xlsheetVendor = xlBook.Worksheets(1) ;	//更新供应商
		var xlsheetManf = xlBook.Worksheets(2) ;	 //更新厂商
		
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
				var code=vStr(xlsheet.Cells(i,1).value);	//供应商代码
				if (code==""){Msg.info("error","供应商代码不可为空,请检查文件!!");Ext.getCmp("update").setDisabled(true);}
				var name=vStr(xlsheet.Cells(i,2).value);	//供应商名称
				if (name==""){Msg.info("error","供应商名称不可为空,请检查文件!!");Ext.getCmp("update").setDisabled(true);}
				var tel	=vStr(xlsheet.Cells(i,3).value);	//供应商电话
				var contact	=vStr(xlsheet.Cells(i,4).value);	//开户行
				var account	=vStr(xlsheet.Cells(i,5).value);	//账号
				var purchaseAmtLtd	=vStr(xlsheet.Cells(i,6).value);	//采购限额
				var cats=vStr(xlsheet.Cells(i,7).value);	//供应商分类
				var contractenddate	=vDate(xlsheet.Cells(i,8).value);	//合同截止日期
//				alert(contractenddate)
				var fax	=vStr(xlsheet.Cells(i,9).value);	//传真
				var legal_representative	=vStr(xlsheet.Cells(i,10).value);	//法人代表
				var address	=vStr(xlsheet.Cells(i,11).value);	//地址
				var comLic	=vStr(xlsheet.Cells(i,12).value);//	工商执照
				var comLic_ExpDate	=vDate(xlsheet.Cells(i,13).value);	//工商执照有效期
				var taxLic	=vStr(xlsheet.Cells(i,14).value);	//税务登记
				var taxLic_ExpDate	=vDate(xlsheet.Cells(i,15).value);	//税务登记效期
				var insBusLic=vStr(xlsheet.Cells(i,16).value);//	医疗器械经营许可证
				var insBusLic_ExpDate=vDate(xlsheet.Cells(i,17).value);	//效期
				
				var proPermit=vStr(xlsheet.Cells(i,18).value);  //生产制造认可表	
				var proPermit_ExpDate=vDate(xlsheet.Cells(i,19).value);  //效期	 
				
				var insRegLic	=vStr(xlsheet.Cells(i,20).value);	//医疗器械注册证
				var insRegLic_ExpDate=vDate(xlsheet.Cells(i,21).value);	//	效期
				var hygLic=vStr(xlsheet.Cells(i,22).value);	//	卫生许可证
				var hygLic_ExpDate=vDate(xlsheet.Cells(i,23).value);		//效期
				var orgCode	=vStr(xlsheet.Cells(i,24).value);	//组织机构代码
				var orgCode_ExpDate	=vDate(xlsheet.Cells(i,25).value);	//效期
				var Gsp	=vStr(xlsheet.Cells(i,26).value);	//Gsp
				var Gsp_ExpDate	=vDate(xlsheet.Cells(i,27).value);	//Gsp效期
				var insProLic=vStr(xlsheet.Cells(i,28).value);	//	器械生产许可证
				var insProLic_ExpDate=vDate(xlsheet.Cells(i,29).value);	//	效期		
				var inletRLic	=vStr(xlsheet.Cells(i,30).value);	//进口医疗器械注册证
				var inletRLic_ExpDate=vDate(xlsheet.Cells(i,31).value);//	效期	
				var inletRegLic	=vStr(xlsheet.Cells(i,32).value);	//进口注册登记表
				var inletRegLic_ExpDate	=vDate(xlsheet.Cells(i,33).value);//	效期
				var agentAuth	=vStr(xlsheet.Cells(i,34).value);	//代理销售授权书
				var agentAuth_ExpDate=vDate(xlsheet.Cells(i,35).value);	//	效期
				var serviceComm	=vStr(xlsheet.Cells(i,36).value);//售后服务承诺书
				var legalComm	=vStr(xlsheet.Cells(i,37).value);	//	法人委托书
				var qualityComm	=vStr(xlsheet.Cells(i,38).value);//质量承诺书
				var qualityComm_ExpDate	=vDate(xlsheet.Cells(i,39).value);	//质量承诺书有效期
				var salesmanName	=vStr(xlsheet.Cells(i,40).value);	//业务员姓名
				var salesmanAuth_ExpDate	=vDate(xlsheet.Cells(i,41).value);//	业务员授权书有效期
				var salesmanTel=vStr(xlsheet.Cells(i,42).value);	//业务员电话
				
				var result_str="";
				var Code=code;   //(1)
				var Name=name;  //(2)
				var Tel=tel;  //(3)
				var ConPerson=contact;//(4)
				var CtrlAcct=account ;//(5)
				var CrLimit= purchaseAmtLtd ;//(6)		
				var Fax=fax ; //(7)
				var President= legal_representative ;//(8) -法人代表
				var PresidentId="";	//(9)  -法人代表身份证号
				var Status="" ;//(10)
				result_str=Code+"^"+Name+"^"+Tel+"^"+ConPerson+"^"+CtrlAcct+"^"+CrLimit+"^"+Fax+"^"+President+"^"+PresidentId+"^"+Status;
				var CategoryId=cats ;//(11)
				
				var CrAvail="" ;  //(12)  -注册资金
				var LstPoDate=contractenddate ; //(13)  -合同截至日期
				var Address=address;  //(14)
				var RCFlag="";  //(15)
				var ComLic=comLic  ;//(16)
				var ComLicDate=comLic_ExpDate ; //(17)
				var AgentLic=agentAuth ; //(18)
				var DrugManLic="" ; //(19)   药品经营许可证
				var DrugManLicDate="" ;  //(20) 药品经营许可证效期
				result_str=result_str+"^"+CategoryId+"^"+CrAvail+"^"+LstPoDate+"^"+Address+"^"+RCFlag+"^"+ComLic+"^"+ComLicDate+"^"+AgentLic+"^"+DrugManLic+"^"+DrugManLicDate;
				var Gsp=Gsp;  // (21)
				var GspDate=Gsp_ExpDate ; //(22)	
				var ImportEnrol=inletRLic ; //(23)
				var ImportEnrolDate=inletRLic_ExpDate;  //(24)
				var ImportLic=inletRegLic;//(25)
				var ImportLicDate=inletRegLic_ExpDate ;//(26)
				var MatEnrol=insRegLic  ; //(27)   - 医疗器械注册证
				var MatEnrolDate=insRegLic_ExpDate ;   //(28)
				var MatManLic=insBusLic ;//(29)  - 医疗器械经营许可证
				var MatManLicDate=insBusLic_ExpDate; //(30)		
				result_str=result_str+"^"+Gsp+"^"+GspDate+"^"+ImportEnrol+"^"+ImportEnrolDate+"^"+ImportLic+"^"+ImportLicDate+"^"+MatEnrol+"^"+MatEnrolDate+"^"+MatManLic+"^"+MatManLicDate;
				var MatPro=insProLic;  //(31) - 器械生产许可证
				var MatProDate=insProLic_ExpDate ; //(32)
				var OrgCode=orgCode ; // (33)
				var OrgCodeDate=orgCode_ExpDate;  // (34)	
				var Promises=serviceComm;  //(35)  - 售后服务承诺书
				var ProPermit=proPermit ;//(36)   - 生产制造许可表
				var ProPermitDate=proPermit_ExpDate;   //(37)
				var RevReg=taxLic;   //(38) -税务登记号
				var RevRegDate=taxLic_ExpDate ;  //(39)
				var Sanitation=hygLic ; //(40)  -卫生许可证
				result_str=result_str+"^"+MatPro+"^"+MatProDate+"^"+OrgCode+"^"+OrgCodeDate+"^"+Promises+"^"+ProPermit+"^"+ProPermitDate+"^"+RevReg+"^"+RevRegDate+"^"+Sanitation;
				var SanitationDate=hygLic_ExpDate;//(41)
				var TrustDeed=legalComm;  //(42)  -法人委托书
				var Quality=qualityComm ; //(43)
				var QualityDate=qualityComm_ExpDate ; //(44)
				var AgentLicDate=agentAuth_ExpDate ; //(45)  -代理授权书效期
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
			alert('读取Excel文件供应商信息错误:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}
		
		var startRow=2;
		var myData2 = [];
		try{
			for (var i=startRow;i<1000;i++)
			{
				var result_str="";
				
				var Code=vStr(xlsheet2.Cells(i,1).value);
				//if (Code==""){Msg.info("error","厂商代码不可为空,请检查文件!");Ext.getCmp("update").setDisabled(true);}
				var Name =vStr(xlsheet2.Cells(i,2).value); 
				//if (Name==""){Msg.info("error","厂商名称不可为空,请检查文件!");Ext.getCmp("update").setDisabled(true);}
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
			alert('读取Excel文件厂商信息错误:'+e);
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
					if (name=="") 	{var info='导入供应商';}
					else  {var info='更新供应商';}
					Msg.info('success',info+'成功!');
//					var rowid = jsonData.info;
//					currVendorRowId=rowid;
//					CreateEditWin();
				}
				else
				{
					Msg.info('error','失败');
				}
			},
			failure: function(result, request) {
				Msg.info('error','失败!');
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
					if (name=="") 	{var info='导入厂商';}
					else  {var info='更新厂商';}
					Msg.info('success',info+'成功!');
					//var rowid = jsonData.info;
					//CreateEditWin(rowid);
				}
				else
				{
					Msg.info('error','失败');
				}
			},
			failure: function(result, request) {
				Msg.info('error','失败!');
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
		