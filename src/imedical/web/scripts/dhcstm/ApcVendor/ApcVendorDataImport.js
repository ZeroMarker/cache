 
 /*供应商数据导入*/
var cmVenX;
var cmManfX;
var cmIncItmX;

var vendorCodeStr="";  //供应商代码串("^"分隔)
var manfNameStr="";  //厂商名称串("^"分隔)
var itmCodeStr="" ;  //代码串
var regNoStr=""  //注册证号串

var home_path="";
var FTPX;

var ftpServerIp="";
var ftpUser="";
var ftpPass="";
var ftpPort="";

var home_path="E:\\GZ-工作文档\\Customer\\TRYYNQ-同仁医院南区\\供应商数据导入\\示例数据";

/*全局变量*/
var vendorPicFiles="";
var manfPicFiles="";
var itmPicFiles="";
var saPicFiles="";
		
var vendor_pic_path=home_path+"\\"+"供应商图片";
var manf_pic_path=home_path+"\\"+"生产厂商图片";
var supply_authoriz_path=home_path+"\\"+"授权资质图片";
var itm_pic_path=home_path+"\\"+"物资图片"


var vendor_data_file=home_path+"\\"+"供应商字典表.xls";
var manf_data_file=home_path+"\\"+"生产厂商字典表.xls";
var itm_data_file=home_path+"\\"+"基础数据字典表.xls";
 

 // /*供应商资质文件名称*/
// function vendor_pic_filename(filename) 
// {
	// var fn=home_path+"/"+vendor_pic_path+"/"+filename;
	// return fn;
// }

 // /*生产厂家资质文件名称*/
 // function manf_pic_filename(filename) 
 // {
	// var fn=home_path+"/"+filename;
	// return fn;
// }

 /* function vendor_data_filename()
{
	var fn=home_path+"/"+vendor_data_file
	return fn;
}

function manf_data_filename()
{
	var fn=home_path+"/"+manf_data_file
	return fn;
}

function itm_data_filename()
{
	var fn=home_path+"/"+itm_data_file
	return fn;
} */ 


var VendorExcelData="";
var ManfExcelData="";
var ItmExcelData="";


var pathName=new Ext.form.TextField({
	id:'pathName',
	// fieldLabel:'数据文件夹路径',
	// allowBlank:true,
	listWidth:300,
	width:300,
	value:'E:\\vendor\\',
	// anchor:'90%',
	selectOnFocus:true
});


	/* 	供货商名称	
		供货商级别	
		开户行名称	
		银行账号	
		地址		
		座机电话	
		营业执照	
		营业执照效期	
		税务登记证	
		医疗器械经营许可证	
		医疗器械经营许可证效期	
		组织机构代码证	
		组织机构代码效期	
		医疗器械生产许可证	
		医疗器械生产许可证效期	
		I类生产许可登记表	
		业务员授权书	
		业务员授权书有效期	
		业务员姓名	
		业务员手机号码	
		配送手机号码 */
	
	cmVenX=new Ext.grid.ColumnModel(
		[{header:'供货商代码',dataIndex:'Code'},  //新增
		{header:'供货商名称',dataIndex:'Name'},
		{header:'供货商级别',dataIndex:'CategoryId'},
		{header:'开户行名称',dataIndex:'ConPerson'},	
		{header:'银行账号',dataIndex:'CtrlAcct'},
		{header:'地址',dataIndex:'Address'},		
		{header:'座机电话',dataIndex:'Tel'},		
		{header:'营业执照',dataIndex:'ComLic'},
		{header:'营业执照效期',dataIndex:'ComLicDate'},		
		{header:'税务登记证',dataIndex:'RevReg'},
		{header:'医疗器械经营许可证',dataIndex:'MatManLic'},
		{header:'医疗器械经营许可证效期',dataIndex:'MatManLicDate'},	
		{header:'组织机构代码证',dataIndex:'OrgCode'},
		{header:'组织机构代码效期',dataIndex:'OrgCodeDate'},	
		{header:'医疗器械生产许可证',dataIndex:'MatPro'},
		{header:'医疗器械生产许可证效期',dataIndex:'MatProDate'},	
		{header:'I类生产许可登记表',dataIndex:'ProPermit'},		
		{header:'业务员授权书',dataIndex:'SalesLic'},   //新增
		{header:'业务员授权书有效期',dataIndex:'SalesLicDate'},
		{header:'业务员姓名',dataIndex:'SalesName'},
		{header:'业务员手机号码',dataIndex:'SalesTel'},
		{header:'配送手机号码',dataIndex:'CarrierTel'}		
		]
		) ;
		
	var venRecX = Ext.data.Record.create([
	    {name: 'Code'},
	    {name: 'Name'},
	    {name:'CategoryId'},	
	    {name:'ConPerson'},	
	    {name:'CtrlAcct'},		
	    {name:'Address'},
		{name:'Tel'},
	    {name:'ComLic'},		
	    {name:'ComLicDate'},		
		{name:'RevReg'},
		{name:'MatManLic'},	
		{name:'MatManLicDate'},	
		{name:'OrgCode'},
		{name:'OrgCodeDate'},	
		{name:'MatPro'},
		{name:'MatProDate'},	
		{name:'ProPermit'},
	    {name:'SalesLic'},		
		{name:'SalesLicDate'},		
		{name:'SalesName'},
		{name:'SalesTel'},
		{name:'CarrierTel'}
	
	]);

	/* 	
	生产厂家名称	
	生产厂家分类	
	营业执照	
	营业执照效期	
	组织机构代码证	
	组织机构代码证效期	
	税务登记证	
	医疗器械生产经营许可证	
	医疗器械生产经营许可证效期	
	I类生产许可登记表 
	*/
	
	cmManfX = new Ext.grid.ColumnModel([
	    {header:'生产厂家名称',dataIndex:'Name'}, 
		{header:'生产厂家分类',dataIndex:'CategoryId'},  //新增
	    {header:'营业执照',dataIndex:'ComLic'},
	    {header:'营业执照效期',dataIndex:'ComLicExp'},	
	    {header:'组织机构代码证',dataIndex:'OrgCode'},
	    {header:'组织机构代码证效期',dataIndex:'OrgCodeExpDate'},		
	    {header:'税务登记证',dataIndex:'TaxRegNo'},		
	    {header:'医疗器械生产经营许可证',dataIndex:'MatPermit'},
	    {header:'医疗器械生产经营许可证效期',dataIndex:'MatPermitExp'},	
	    {header:'I类生产许可登记表',dataIndex:'ProPermitRegForm'} //新增	
	  
	]);	 
	
	var manfRecX = Ext.data.Record.create([
	    {name: 'Name'},
		{name: 'CategoryId'},
	    {name:'ComLic'},
	    {name:'ComLicExp'},	    
	    {name:'OrgCode'},
	    {name:'OrgCodeExpDate'},	
		{name:'TaxRegNo'},		
		{name:'MatPermit'},
	    {name:'MatPermitExp'},
		{name:'ProPermitRegForm'}	
	]);

	/* 
	物资状态说明	
	同仁码	
	物资名	
	供货商价格	
	物价码	
	物价名	
	物价价格	
	收费标志	
	名称	
	规格型号	
	具体规格	
	物品类别	
	一次性标志	
	品牌	
	单位	
	最小送货单位	
	配送电话(手机)	
	进口(国产)标志	
	医疗器械注册证号	
	医疗器械注册证图片	
	存储条件	
	国(省)别	
	高值类标志	
	植入标志	
	效期长度(月)	
	是否有物资中文说明书	
	物资使用说明书	
	物资图片	
	消毒灭菌长度(月)	
	消毒灭菌方式	
	医疗器械注册证截止日期	
	生产厂商	
	一级代理授权书	
	一级代理授权效期	
	一级代理公司名称	
	一级代理公司资质图片	
	二级代理授权书	
	二级代理授权效期	
	二级代理公司名称	
	二级代理公司资质图片	
	三级代理授权书	
	三级代理授权效期	
	供应商名称	
	数据录入人	
	录入人联系电话	 
	*/																																																																																																																																																																																																														
	
	cmIncItmX = new Ext.grid.ColumnModel([
	    {header:'物资状态说明',dataIndex: 'NotUse'}, 
	    {header:'同仁码',dataIndex: 'TongRenCode'}, 
	    {header:'物资名',dataIndex: 'Abbre'}, 
	    {header:'供货商价格',dataIndex: 'Rp'}, 
	    {header:'物价码',dataIndex: 'PriceCode'}, 
	    {header:'物价名',dataIndex: 'PriceDesc'}, 
	    {header:'物价价格',dataIndex: 'Sp'}, 
	    {header:'收费标志',dataIndex: 'ChargeFlag'}, 
	    {header:'名称',dataIndex: 'Desc'}, 
	    {header:'规格型号',dataIndex: 'Spec'}, 
		{header:'具体规格',dataIndex: 'SpecList'}, 
		{header:'物品类别',dataIndex: 'Cat'}, 	  
		{header:'一次性标志',dataIndex: 'BAFlag'}, 
		{header:'品牌',dataIndex: 'Brand'}, 	  
		{header:'单位',dataIndex: 'UOM'}, 
		{header:'最小送货单位',dataIndex: 'PUOM'}, 	  
		{header:'配送电话(手机)',dataIndex: 'CarrTel'}, 
		{header:'进口(国产)标志',dataIndex: 'ImportFlag'}, 	  
		{header:'医疗器械注册证号',dataIndex: 'RegNo'}, 
		{header:'医疗器械注册证图片',dataIndex: 'RegNoPicName'}, 	  
		{header:'存储条件',dataIndex: 'StorageCon'}, 
		{header:'国(省)别',dataIndex: 'ComFrom'}, 	  
		{header:'高值类标志',dataIndex: 'HighPrice'}, 
		{header:'植入标志',dataIndex: 'ImplantFlag'}, 	  
		{header:'效期长度(月)',dataIndex: 'ExpireLen'}, 
		{header:'是否有物资中文说明书',dataIndex: 'DrugUseFlag'}, 	  
		{header:'物资使用说明书',dataIndex: 'DrugUse'}, 
		{header:'物资图片',dataIndex: 'PackFilePath'}, 	  
		{header:'消毒灭菌长度(月)',dataIndex: 'SterileDateLen'}, 
		{header:'消毒灭菌方式',dataIndex: 'SterileCat'}, 	  
		{header:'医疗器械注册证截止日期',dataIndex: 'RegNoExpDate'}, 
		{header:'生产厂商',dataIndex: 'Manf'}, 	  
		{header:'一级代理授权书',dataIndex: 'OneLevelAgentLic'}, 
		{header:'一级代理授权效期',dataIndex: 'OneLevelAgentLicExp'}, 	  
		{header:'一级代理公司名称',dataIndex: 'OneLevelAgentName'}, 
		{header:'一级代理公司资质图片',dataIndex: 'OneLevelAgentQual'}, 	  
		{header:'二级代理授权书',dataIndex: 'TwoLevelAgentLic'}, 
		{header:'二级代理授权效期',dataIndex: 'TwoLevelAgentLicExp'}, 	  
		{header:'二级代理公司名称',dataIndex: 'TwoLevelAgentName'}, 
		{header:'二级代理公司资质图片',dataIndex: 'TwoLevelAgentQual'}, 	  
		{header:'三级代理授权书',dataIndex: 'ThreeLevelAgentLic'}, 
		{header:'三级代理授权效期',dataIndex: 'ThreeLevelAgentLicExp'}, 	  
		{header:'供应商名称',dataIndex: 'VendorName'}, 
		{header:'数据录入人',dataIndex: 'VendorUser'}, 	  
		{header:'录入人联系电话',dataIndex: 'VendorUserTel'}
	]);	 
		
	var incitmRecX= Ext.data.Record.create([
	    {name: 'NotUse'}, 
	    {name: 'TongRenCode'}, 
	    {name: 'Abbre'}, 
	    {name: 'Rp'}, 
	    {name: 'PriceCode'}, 
	    {name: 'PriceDesc'}, 
	    {name: 'Sp'}, 
	    {name: 'ChargeFlag'}, 
	    {name: 'Desc'}, 
	    {name: 'Spec'}, 
		{name: 'SpecList'}, 
		{name: 'Cat'}, 	  
		{name: 'BAFlag'}, 
		{name: 'Brand'}, 	  
		{name: 'UOM'}, 
		{name: 'PUOM'}, 	  
		{name: 'CarrTel'}, 
		{name: 'ImportFlag'}, 	  
		{name: 'RegNo'}, 
		{name: 'RegNoPicName'}, 	  
		{name: 'StorageCon'}, 
		{name: 'ComFrom'}, 	  
		{name: 'HighPrice'}, 
		{name: 'ImplantFlag'}, 	  
		{name: 'ExpireLen'}, 
		{name: 'DrugUseFlag'}, 	  
		{name: 'DrugUse'}, 
		{name: 'PackFilePath'}, 	  
		{name: 'SterileDateLen'}, 
		{name: 'SterileCat'}, 	  
		{name: 'RegNoExpDate'}, 
		{name: 'Manf'}, 	  
		{name: 'OneLevelAgentLic'}, 
		{name: 'OneLevelAgentLicExp'}, 	  
		{name: 'OneLevelAgentName'}, 
		{name: 'OneLevelAgentQual'}, 	  
		{name: 'TwoLevelAgentLic'}, 
		{name: 'TwoLevelAgentLicExp'}, 	  
		{name: 'TwoLevelAgentName'}, 
		{name: 'TwoLevelAgentQual'}, 	  
		{name: 'ThreeLevelAgentLic'}, 
		{name: 'ThreeLevelAgentLicExp'}, 	  
		{name: 'VendorName'}, 
		{name: 'VendorUser'}, 	  
		{name: 'VendorUserTel'}
	]);
	
					
	var reader =  new Ext.data.ArrayReader(
		{
			idIndex: 0  // id for each record will be the first element
		},
		venRecX // recordType
	);

	var reader2 =  new Ext.data.ArrayReader(
		{
			idIndex: 0  // id for each record will be the first element
		},
		manfRecX // recordType
	);	
		
	var reader3 =  new Ext.data.ArrayReader(
		{
			idIndex: 0  // id for each record will be the first element
		},
		incitmRecX // recordType
	);		
	    	    
	
	var store1=new Ext.data.Store({
		reader:reader
	});
		
	var store2=new Ext.data.Store({
		reader:reader2
	});
	var store3=new Ext.data.Store({
		reader:reader3
	});
		

	var gridVendorX=new Ext.grid.GridPanel({
		title:'1 -供应商信息',
		cm:cmVenX,
		height:200,
		split:true,
	    store:store1,
		region:'north'
		});
	
	var gridManfX=new Ext.grid.GridPanel({
		title:'2 -厂商信息',
		cm:cmManfX,
		split:true,
		store:store2,
		region:'center'
	})
 	
	var gridIncItmX=new Ext.grid.GridPanel({
		title:'3 -物资字典信息',
		cm:cmIncItmX,
		store:store3,
		split:true,
		height:200
		,
		region:'south'
	})
	var tpath=new Ext.Toolbar.Button({
		text:'数据文件夹路径:'
	});
	var tReadFile=new Ext.Toolbar.Button({
		text:'读取数据',
		iconCls:'page_edit',
		id:'Read',
		handler:function()
		{
			ReadFromExcel();
		}
	});
	
	var t1=new Ext.Toolbar.Button({
		text:'执行更新',
		iconCls:'page_edit',
		id:'update',
		handler:function()
		{
//			alert(VendorExcelData);
//			alert(ManfExcelData);
		// alert(CellInd(cmVenX,"ComLicDate"))
			// UpdVendorPic(vendorPicFiles);
			ftpConfig();
			
		// var files=searchFiles(vendor_pic_path+"\\"+"02410",picName);
			// alert(vendorPicFiles);
			/* 
			  if (VendorExcelData!='')
			{
				UpdVendor(VendorExcelData);
			}
			
			if (ManfExcelData!='')
			{
				UpdManf(ManfExcelData);
			}			
			
			if (ItmExcelData!='')
			{
				UpdItm(ItmExcelData);
			}	 */  
			
			
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
	
	

	/*读取供应商数据*/
	function ReadFromExcel()
	{
		// var Template=fileName;
		// var xlApp = new ActiveXObject("Excel.Application");
		// var xlBook = xlApp.Workbooks.Add(Template);	
		// var xlsheetVendor = xlBook.Worksheets(1) ;	//更新供应商
		// var xlsheetManf = xlBook.Worksheets(2) ;	 //更新厂商
		// if (xlApp)	{ReadVendorFromExcel(xlApp,xlBook,xlsheetVendor,xlsheetManf); }
		
		// alert(itm_data_file);
		
		ReadVendorFromExcel(vendor_data_file);
		 ReadManfFromExcel(manf_data_file);
		 ReadItmFromExcel(itm_data_file);
		
	}
	

	function ReadManfFromExcel(fileName)
	{
		var Template=fileName;
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);	
		var xlsheet = xlBook.Worksheets(1) ;	//更新厂商
		
		if (!xlApp)	{return;}
		ManfExcelData="";
		var startRow=2;
		var myData2 = [];
		var mp="";
		
		try{
			for (var i=startRow;i<1000;i++)
			{
				var result_str="";
				var ind=CellInd(cmManfX,"Code");
				var Code="";
				if (ind>0) { Code=vStr(xlsheet.Cells(i,ind).value);	
				}
					
				//if (Code==""){Msg.info("error","厂商代码不可为空,请检查文件!");Ext.getCmp("update").setDisabled(true);}
				var ind=CellInd(cmManfX,"Name");
				var Name="";
				if (ind>0)  {
					Name =vStr(xlsheet.Cells(i,ind).value); 
				}
				
				//if (Name==""){Msg.info("error","厂商名称不可为空,请检查文件!");Ext.getCmp("update").setDisabled(true);}
				if (Name=='') break;
				var ind=CellInd(cmManfX,"CategoryId");
				CategoryId=vStr(xlsheet.Cells(i,ind).value); 
				// var Address	=vStr(xlsheet.Cells(i,3).value);
				// var Tel=vStr(xlsheet.Cells(i,4).value);
				// var ParManfId =vStr(xlsheet.Cells(i,5).value);
				// var DrugPermit	=vStr(xlsheet.Cells(i,6).value);
				// var DrugPermitExp	=vDate(xlsheet.Cells(i,7).value);
				var ind=CellInd(cmManfX,"MatPermit");
				var MatPermit	=vStr(xlsheet.Cells(i,ind).value);
				if (MatPermit!="") 
				{	
					var pics=picstr(manf_pic_path+"\\"+Name,MatPermit,"MatPermit") ;
					if (mp=="") {mp=pics;}
					else {mp=mp+"!"+pics;}
				}		
				var ind=CellInd(cmManfX,"MatPermitExp");
				var MatPermitExp =vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmManfX,"ComLic");
				var ComLic =vStr(xlsheet.Cells(i,ind).value);
				if (ComLic!="") 
				{	
					var pics=picstr(manf_pic_path+"\\"+Name,ComLic,"ComLic") ;
					if (mp=="") {mp=pics;}
					else {mp=mp+"!"+pics;}
				}				
				
				var ind=CellInd(cmManfX,"ComLicExp");
				var ComLicExp  =vDate(xlsheet.Cells(i,ind).value);
				
				// result_str=Code+"^"+Name+"^"+Address+"^"+Tel+"^"+ParManfId+"^"+DrugPermit+"^"+DrugPermitExp+"^"+MatPermit+"^"+MatPermitExp+"^"+ComLic;
				// var Active="";
				// var BusinessRegNo  =vStr(xlsheet.Cells(i,12).value);
				// var BusinessRegExpDate=vDate(xlsheet.Cells(i,13).value);
				var ind=CellInd(cmManfX,"OrgCode");
				var OrgCode	=vStr(xlsheet.Cells(i,ind).value);
				if (OrgCode!="") 
				{	
					var pics=picstr(manf_pic_path+"\\"+Name,OrgCode,"OrgCode") ;
					if (mp=="") {mp=pics;}
					else {mp=mp+"!"+pics;}
				}	
				 ind=CellInd(cmManfX,"OrgCodeExpDate");
				var OrgCodeExpDate	=vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmManfX,"TaxRegNo");
				var TaxRegNo   =vStr(xlsheet.Cells(i,ind).value);
				if (TaxRegNo!="") 
				{	
					var pics=picstr(manf_pic_path+"\\"+Name,TaxRegNo,"TaxRegNo") ;
					if (mp=="") {mp=pics;}
					else {mp=mp+"!"+pics;}
				}	
				var ind=CellInd(cmManfX,"ProPermitRegForm");
				ProPermitRegForm=vStr(xlsheet.Cells(i,ind).value);
				
				// var MatManLic =vStr(xlsheet.Cells(i,17).value);
				// var MatManLicDate	=vDate(xlsheet.Cells(i,18).value);
				// result_str=result_str+"^"+ComLicExp+"^"+Active+"^"+BusinessRegNo+"^"+BusinessRegExpDate+"^"+OrgCode+"^"+OrgCodeExpDate+"^"+TaxRegNo+"^"+MatManLic+"^"+MatManLicDate;
				
				if (Code==""){Code=Name;}   //用名称做代码 
				result_str=Code+"^"+Name+"^"+CategoryId +"^"+ ComLic+"^"+ComLicExp +"^"+ OrgCode+"^"+OrgCodeExpDate+"^"+TaxRegNo +"^"+MatPermit +"^"+MatPermitExp+"^"+ProPermitRegForm
				// alert(result_str);
				if (ManfExcelData=='')
					{ManfExcelData =result_str;}
				else
					{ManfExcelData =ManfExcelData + xRowDelim()+result_str;}			
				var manfArr=[Code,Name,CategoryId , ComLic,ComLicExp , OrgCode,OrgCodeExpDate,TaxRegNo ,MatPermit ,MatPermitExp,ProPermitRegForm] ;
				myData2.length=myData2.length+1;
				myData2[myData2.length-1]=manfArr;
				
				
				if (mp!="")
				{
					if (manfPicFiles=="")
					{
						manfPicFiles=Name+"$"+mp;
					}
					else
					{
						manfPicFiles=manfPicFiles+xRowDelim()+Name+"$"+mp	;
					}
				}				
			}		
			store2.loadData(myData2);
		}
		catch(e)
		{
			alert('读取Excel文件厂商信息错误:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}				
		
	}
	
	function ReadItmFromExcel(fileName)
	{
		var Template=fileName;
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);	
		var xlsheet = xlBook.Worksheets(1) ;	//更新供应商		
		if (!xlApp)	{return;}
	 	ItmExcelData="";		
		
		var startRow=2;
		var myData3 = [];
		var ip="";
		var sap="" ; //授权串
		
		try{
			for (var i=startRow;i<1000;i++)
			{
				var result_str="";
				var ind=CellInd(cmIncItmX,"NotUse");    //物资状态说明
				if (ind>0) { NotUse=vStr(xlsheet.Cells(i,ind).value);					}
					
				var ind=CellInd(cmIncItmX,"TongRenCode");  //同仁码
				var TongRenCode="";
				if (ind>0)  {
					TongRenCode =vStr(xlsheet.Cells(i,ind).value); 
				}
				var ind=CellInd(cmIncItmX,"Abbre");  //物资名
				Abbre=vStr(xlsheet.Cells(i,ind).value); 
				var ind=CellInd(cmIncItmX,"Rp");  //供货商价格
				var Rp	=vStr(xlsheet.Cells(i,ind).value);
				
				var ind=CellInd(cmIncItmX,"PriceCode"); //物价码
				var PriceCode =vDate(xlsheet.Cells(i,ind).value);  
				
				var ind=CellInd(cmIncItmX,"PriceDesc"); //物价名
				var PriceDesc =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Sp");  //物价价格
				var Sp  =vDate(xlsheet.Cells(i,ind).value);

				var ind=CellInd(cmIncItmX,"ChargeFlag");  //收费标志
				var  ChargeFlag=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Desc");  //名称
				var  Desc=vStr(xlsheet.Cells(i,ind).value);
				if (Desc=='') break;
				var ind=CellInd(cmIncItmX,"Spec");  //规格型号
				var  Spec=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"SpecList");  //具体规格
				var  SpecList=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Cat");  //物品类别
				var  Cat=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"BAFlag");  //一次性标志
				var  BAFlag=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Brand");  //品牌
				var  Brand=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"UOM");  //单位
				var  UOM=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"PUOM");  //最小送货单位
				var  PUOM=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"CarrTel");  //配送电话(手机)
				var CarrTel =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"ImportFlag");  //进口(国产)标志
				var ImportFlag =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"RegNo");  //医疗器械注册证号
				var  RegNo=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"RegNoPicName");  //医疗器械注册证图片
				var  RegNoPicName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"StorageCon");  //存储条件
				var  StorageCon=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"ComFrom");  //国(省)别
				var  ComFrom=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"HighPrice");  //高值类标志
				var  HighPrice=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"ImplantFlag");  //植入标志
				var  ImplantFlag=vStr(xlsheet.Cells(i,ind).value);
				// alert('sss');
				var ind=CellInd(cmIncItmX,"ExpireLen");  //效期长度(月)
				var  ExpireLen=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"DrugUseFlag");  //是否有物资中文说明书  ?????????????????????????????
				var DrugUseFlag =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"DrugUse");  //物资使用说明书
				var DrugUse =vStr(xlsheet.Cells(i,ind).value);
				if (DrugUse!="") 
				{	
					var pics=picstr(itm_pic_path+"\\"+TongRenCode,DrugUse,"DrugUse") ;
					if (ip=="") {ip=pics;}
					else {ip=ip+"!"+pics;}
				}
				var ind=CellInd(cmIncItmX,"PackFilePath");  //物资图片
				var  PackFilePath=vStr(xlsheet.Cells(i,ind).value);
				if (PackFilePath!="") 
				{	
					var pics=picstr(itm_pic_path+"\\"+TongRenCode,PackFilePath,"productMaster") ;
					if (ip=="") {ip=pics;}
					else {ip=ip+"!"+pics;}
				}				

				var ind=CellInd(cmIncItmX,"SterileDateLen");  //消毒灭菌长度(月)
				var SterileDateLen =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"SterileCat");  //消毒灭菌方式
				var SterileCat =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"RegNoExpDate");  //医疗器械注册证截止日期
				var RegNoExpDate =vDate(xlsheet.Cells(i,ind).value);
				// alert('ttt');
				var ind=CellInd(cmIncItmX,"Manf");  //生产厂商
				var Manf=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"OneLevelAgentLic");  //一级代理授权书
				var OneLevelAgentLic =vStr(xlsheet.Cells(i,ind).value);
				
				if (OneLevelAgentLic!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,OneLevelAgentLic,"OneLevelAgentLic") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}		
				var ind=CellInd(cmIncItmX,"OneLevelAgentLicExp");  //一级代理授权效期
				var OneLevelAgentLicExp =vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"OneLevelAgentName");  //一级代理公司名称
				var  OneLevelAgentName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"OneLevelAgentQual");  //一级代理公司资质图片
				var OneLevelAgentQual =vStr(xlsheet.Cells(i,ind).value);
				if (OneLevelAgentQual!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,OneLevelAgentQual,"OneLevelAgentQual") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}
				var ind=CellInd(cmIncItmX,"TwoLevelAgentLic");  //二级代理授权书
				var TwoLevelAgentLic =vStr(xlsheet.Cells(i,ind).value);
				if (TwoLevelAgentLic!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,TwoLevelAgentLic,"TwoLevelAgentLic") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}	
				var ind=CellInd(cmIncItmX,"TwoLevelAgentLicExp");  //二级代理授权效期
				var TwoLevelAgentLicExp=vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"TwoLevelAgentName");  //二级代理公司名称
				var TwoLevelAgentName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"TwoLevelAgentQual");  //二级代理公司资质图片
				var TwoLevelAgentQual=vStr(xlsheet.Cells(i,ind).value);
				if (TwoLevelAgentQual!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,TwoLevelAgentQual,"TwoLevelAgentQual") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}
				var ind=CellInd(cmIncItmX,"ThreeLevelAgentLic");  //三级代理授权书
				var  ThreeLevelAgentLic=vStr(xlsheet.Cells(i,ind).value);
				if (ThreeLevelAgentLic!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,ThreeLevelAgentLic,"ThreeLevelAgentLic") ;
					if (sap=="") {sap=pics;}
				}	
				var ind=CellInd(cmIncItmX,"ThreeLevelAgentLicExp");  //三级代理授权效期
				var ThreeLevelAgentLicExp =vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"VendorName");  //供应商名称
				var  VendorName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"VendorUser");  //数据录入人
				var  VendorUser=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"VendorUserTel");  //录入人联系电话
				var  VendorUserTel=vStr(xlsheet.Cells(i,ind).value);
				// alert('vvvv');
				
				result_str=NotUse+"^"+TongRenCode+"^"+Abbre+"^"+Rp+"^"+PriceCode+"^"+PriceDesc+"^"+Sp+"^"+ChargeFlag+"^"+Desc;
				result_str= result_str+"^"+ Spec+"^"+SpecList+"^"+Cat+"^"+BAFlag+"^"+ Brand+"^"+  UOM+"^"+ PUOM+"^"+ CarrTel;
				result_str=result_str+"^"+ImportFlag+"^"+ RegNo+"^"+ RegNoPicName+"^"+ StorageCon+"^"+ ComFrom+"^"+HighPrice+"^"+ImplantFlag;
				result_str=result_str+"^"+ExpireLen+"^"+DrugUseFlag+"^"+DrugUse+"^"+PackFilePath+"^"+SterileDateLen+"^"+SterileCat+"^"+RegNoExpDate+"^"+Manf;
				result_str=result_str+"^"+OneLevelAgentLic+"^"+OneLevelAgentLicExp+"^"+OneLevelAgentName+"^"+OneLevelAgentQual;
				result_str=result_str+"^"+TwoLevelAgentLic+"^"+TwoLevelAgentLicExp+"^"+TwoLevelAgentName+"^"+TwoLevelAgentQual;
				result_str=result_str+"^"+ThreeLevelAgentLic+"^"+ThreeLevelAgentLicExp+"^"+VendorName+"^"+VendorUser+"^"+VendorUserTel;

				// alert(result_str);
				if (ItmExcelData=='')
					{ItmExcelData =result_str;}
				else
					{ItmExcelData =ItmExcelData + xRowDelim()+result_str;}			
				
				var itmArr=[NotUse,TongRenCode,Abbre,Rp,PriceCode,PriceDesc,Sp,ChargeFlag,Desc,Spec,SpecList,Cat,BAFlag,Brand,UOM,PUOM,CarrTel,ImportFlag,RegNo,RegNoPicName,StorageCon,ComFrom,HighPrice,ImplantFlag,ExpireLen,DrugUseFlag,DrugUse,PackFilePath,SterileDateLen,SterileCat,RegNoExpDate,Manf,OneLevelAgentLic,OneLevelAgentLicExp,OneLevelAgentName,OneLevelAgentQual,TwoLevelAgentLic,TwoLevelAgentLicExp,TwoLevelAgentName,TwoLevelAgentQual,ThreeLevelAgentLic,ThreeLevelAgentLicExp,VendorName,VendorUser,VendorUserTel
					]
				myData3.length=myData3.length+1;
				myData3[myData3.length-1]=itmArr;
				
				if (ip!="")
				{
					if (itmPicFiles=="")
					{
						itmPicFiles=TongRenCode+"$"+ip;
					}
					else
					{
						itmPicFiles=itmPicFiles+xRowDelim()+TongRenCode+"$"+ip	;
					}
				}
				
				if (sap!="")
				{
					if (saPicFiles=="")
					{
						saPicFiles=TongRenCode+"$"+sap;
					}
					else
					{
						saPicFiles=saPicFiles+xRowDelim()+TongRenCode+"$"+sap	;
					}
				}
					
				
			}		
			
			store3.loadData(myData3);
		}
		catch(e)
		{
			alert('读取Excel文件厂商信息错误:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}			
	}
	
	 function ReadVendorFromExcel(fileName)
	 {
		var Template=fileName;
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);	
		var xlsheet = xlBook.Worksheets(1) ;	//更新供应商
		
		if (!xlApp)	{return;}
	 	VendorExcelData="";

	 	var startRow=2;
	 	var myData = [];		
		var vp="";
		try{
			for (var i=startRow;i<1000;i++)
			{
				var ind=CellInd(cmVenX,'Code');
				vp="";
				if (ind>=0)
				var code=vStr(xlsheet.Cells(i,ind).value);	//供应商代码
				if (code=="") break;
				if (code==""){Msg.info("error","供应商代码不可为空,请检查文件!!");Ext.getCmp("update").setDisabled(true);}
				var ind=CellInd(cmVenX,'Name');
				var name=vStr(xlsheet.Cells(i,ind).value);	//供应商名称
				if (name==""){Msg.info("error","供应商名称不可为空,请检查文件!!");Ext.getCmp("update").setDisabled(true);}
				
				var ind=CellInd(cmVenX,'Tel');
				var tel	=vStr(xlsheet.Cells(i,ind).value);	//供应商电话
				
				var ind=CellInd(cmVenX,'ConPerson');
				var contact	=vStr(xlsheet.Cells(i,ind).value);	//开户行
				var ind=CellInd(cmVenX,'CtrlAcct');
				var account	=vStr(xlsheet.Cells(i,ind).value);	//账号
				// var purchaseAmtLtd	=vStr(xlsheet.Cells(i,6).value);	//采购限额
				var ind=CellInd(cmVenX,'CategoryId');
				var cats=vStr(xlsheet.Cells(i,ind).value);	//供应商分类
				
				// var contractenddate	=vDate(xlsheet.Cells(i,8).value);	//合同截止日期
				// var fax	=vStr(xlsheet.Cells(i,9).value);	//传真
				// var legal_representative	=vStr(xlsheet.Cells(i,10).value);	//法人代表
				
				var ind=CellInd(cmVenX,'Address');				
				var address	=vStr(xlsheet.Cells(i,ind).value);	//地址
				
				var ind=CellInd(cmVenX,'ComLic');			
				var comLic	=vStr(xlsheet.Cells(i,ind).value);//	工商执照
				if (comLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,comLic,"comLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+xRowDelim()+pics;}
				}
				
				var ind=CellInd(cmVenX,'ComLicDate');			
				var comLic_ExpDate	=vDate(xlsheet.Cells(i,ind).value);	//工商执照有效期
				var ind=CellInd(cmVenX,'RevReg');			
				var taxLic	=vStr(xlsheet.Cells(i,ind).value);	//税务登记
				if (taxLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,taxLic,"taxLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				
				// var taxLic_ExpDate	=vDate(xlsheet.Cells(i,15).value);	//税务登记效期
	
				var ind=CellInd(cmVenX,'MatManLic');			
				var insBusLic=vStr(xlsheet.Cells(i,ind).value);//	医疗器械经营许可证
				if (insBusLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,insBusLic,"insBusLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'MatManLicDate');			
				var insBusLic_ExpDate=vDate(xlsheet.Cells(i,ind).value);	//效期
				var ind=CellInd(cmVenX,'ProPermit');	
				var proPermit=vStr(xlsheet.Cells(i,ind).value);  //生产制造认可表	

				// var proPermit_ExpDate=vDate(xlsheet.Cells(i,19).value);  //效期	 			
				// var insRegLic	=vStr(xlsheet.Cells(i,20).value);	//医疗器械注册证
				// var insRegLic_ExpDate=vDate(xlsheet.Cells(i,21).value);	//	效期
				// var hygLic=vStr(xlsheet.Cells(i,22).value);	//	卫生许可证
				// var hygLic_ExpDate=vDate(xlsheet.Cells(i,23).value);		//效期
				
				var ind=CellInd(cmVenX,'OrgCode');	
				var orgCode	=vStr(xlsheet.Cells(i,ind).value);	//组织机构代码
				if (orgCode!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,orgCode,"orgCode") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'OrgCodeDate');	
				var orgCode_ExpDate	=vDate(xlsheet.Cells(i,ind).value);	//效期
				// var Gsp	=vStr(xlsheet.Cells(i,26).value);	//Gsp
				// var Gsp_ExpDate	=vDate(xlsheet.Cells(i,27).value);	//Gsp效期

				var ind=CellInd(cmVenX,'MatPro');			
				var insProLic=vStr(xlsheet.Cells(i,ind).value);	//	器械生产许可证
				if (insProLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,insProLic,"insProLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'MatProDate');	
				var insProLic_ExpDate=vDate(xlsheet.Cells(i,ind).value);	//	效期	
				
				// var inletRLic	=vStr(xlsheet.Cells(i,30).value);	//进口医疗器械注册证
				// var inletRLic_ExpDate=vDate(xlsheet.Cells(i,31).value);//	效期	
				// var inletRegLic	=vStr(xlsheet.Cells(i,32).value);	//进口注册登记表
				// var inletRegLic_ExpDate	=vDate(xlsheet.Cells(i,33).value);//	效期
				// var agentAuth	=vStr(xlsheet.Cells(i,34).value);	//代理销售授权书
				// var agentAuth_ExpDate=vDate(xlsheet.Cells(i,35).value);	//	效期
				// var serviceComm	=vStr(xlsheet.Cells(i,36).value);//售后服务承诺书
				// var legalComm	=vStr(xlsheet.Cells(i,37).value);	//	法人委托书
				// var qualityComm	=vStr(xlsheet.Cells(i,38).value);//质量承诺书
				// var qualityComm_ExpDate	=vDate(xlsheet.Cells(i,39).value);	//质量承诺书有效期
				
				var ind=CellInd(cmVenX,'SalesName');	
				var salesmanName	=vStr(xlsheet.Cells(i,ind).value);	//业务员姓名
				var ind=CellInd(cmVenX,'SalesLic');	
				var salesmanAuth	=vStr(xlsheet.Cells(i,ind).value);	//业务员授权书
				if (salesmanAuth!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,salesmanAuth,"salesmanAuth") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'SalesLicDate');	
				var salesmanAuth_ExpDate	=vDate(xlsheet.Cells(i,ind).value);//	业务员授权书有效期
				var ind=CellInd(cmVenX,'SalesTel');
				var salesmanTel=vStr(xlsheet.Cells(i,ind).value);	//业务员电话
				var ind=CellInd(cmVenX,'CarrierTel');
				var CarrierTel=vStr(xlsheet.Cells(i,ind).value);  //配送电话
				
				var result_str="";
				var Code=code;   //(1)
				var Name=name;  //(2)
				var Tel=tel;  //(3)
				var ConPerson=contact;//(4)
				var CtrlAcct=account ;//(5)
				// var CrLimit= purchaseAmtLtd ;//(6)		
				// var Fax=fax ; //(7)
				// var President= legal_representative ;//(8) -法人代表
				// var PresidentId="";	//(9)  -法人代表身份证号
				// var Status="" ;//(10)
				// result_str=Code+"^"+Name+"^"+Tel+"^"+ConPerson+"^"+CtrlAcct+"^"+CrLimit+"^"+Fax+"^"+President+"^"+PresidentId+"^"+Status;
				var CategoryId=cats ;//(11)
				
				// var CrAvail="" ;  //(12)  -注册资金
				// var LstPoDate=contractenddate ; //(13)  -合同截至日期
				var Address=address;  //(14)
				// var RCFlag="";  //(15)
				var ComLic=comLic  ;//(16)
				var ComLicDate=comLic_ExpDate ; //(17)
				// var AgentLic=agentAuth ; //(18)
				// var DrugManLic="" ; //(19)   药品经营许可证
				// var DrugManLicDate="" ;  //(20) 药品经营许可证效期
				// result_str=result_str+"^"+CategoryId+"^"+CrAvail+"^"+LstPoDate+"^"+Address+"^"+RCFlag+"^"+ComLic+"^"+ComLicDate+"^"+AgentLic+"^"+DrugManLic+"^"+DrugManLicDate;
				// var Gsp=Gsp;  // (21)
				// var GspDate=Gsp_ExpDate ; //(22)	
				// var ImportEnrol=inletRLic ; //(23)
				// var ImportEnrolDate=inletRLic_ExpDate;  //(24)
				// var ImportLic=inletRegLic;//(25)
				// var ImportLicDate=inletRegLic_ExpDate ;//(26)
				// var MatEnrol=insRegLic  ; //(27)   - 医疗器械注册证
				// var MatEnrolDate=insRegLic_ExpDate ;   //(28)
				var MatManLic=insBusLic ;//(29)  - 医疗器械经营许可证
				var MatManLicDate=insBusLic_ExpDate; //(30)		
				// result_str=result_str+"^"+Gsp+"^"+GspDate+"^"+ImportEnrol+"^"+ImportEnrolDate+"^"+ImportLic+"^"+ImportLicDate+"^"+MatEnrol+"^"+MatEnrolDate+"^"+MatManLic+"^"+MatManLicDate;
				var MatPro=insProLic;  //(31) - 器械生产许可证
				var MatProDate=insProLic_ExpDate ; //(32)
				var OrgCode=orgCode ; // (33)
				var OrgCodeDate=orgCode_ExpDate;  // (34)	
				// var Promises=serviceComm;  //(35)  - 售后服务承诺书
				var ProPermit=proPermit ;//(36)   - 生产制造许可表
				// var ProPermitDate=proPermit_ExpDate;   //(37)
				var RevReg=taxLic;   //(38) -税务登记号
				// var RevRegDate=taxLic_ExpDate ;  //(39)
				// var Sanitation=hygLic ; //(40)  -卫生许可证
				// result_str=result_str+"^"+MatPro+"^"+MatProDate+"^"+OrgCode+"^"+OrgCodeDate+"^"+Promises+"^"+ProPermit+"^"+ProPermitDate+"^"+RevReg+"^"+RevRegDate+"^"+Sanitation;
				// var SanitationDate=hygLic_ExpDate;//(41)
				// var TrustDeed=legalComm;  //(42)  -法人委托书
				// var Quality=qualityComm ; //(43)
				// var QualityDate=qualityComm_ExpDate ; //(44)
				// var AgentLicDate=agentAuth_ExpDate ; //(45)  -代理授权书效期
				
				var SalesName=salesmanName ; //(46)
				var SalesLic=salesmanAuth;
				var SalesLicDate=salesmanAuth_ExpDate ; //(47)
				var SalesTel=salesmanTel;  //(48)
				
				// result_str=result_str+"^"+SanitationDate+"^"+TrustDeed+"^"+Quality+"^"+QualityDate+"^"+AgentLicDate+"^"+SalesName+"^"+SalesLicDate+"^"+SalesTel;
				// VendorExcelData = result_str;	
				result_str=Code+"^"+Name+"^"+CategoryId+"^"+ConPerson+"^"+CtrlAcct+"^"+Address+"^"+Tel+"^"+ComLic+"^"+ComLicDate+"^"+RevReg+"^"+MatManLic+"^"+MatManLicDate+"^"+OrgCode+"^"+OrgCodeDate+"^"+MatPro+"^"+MatProDate+"^"+ProPermit+"^"+SalesLic+"^"+SalesLicDate+"^"+SalesName+"^"+SalesTel+"^"+CarrierTel;
	  			
				if (VendorExcelData=="") 
				{VendorExcelData=result_str;}
				else {
					VendorExcelData=VendorExcelData+xRowDelim()+result_str ;
				}
		
	  			// var venArr=  [Code,Name,Tel,ConPerson,CtrlAcct,CrLimit,Fax,President,PresidentId,Status,CategoryId,CrAvail,LstPoDate,Address,RCFlag,
				// ComLic,ComLicDate,AgentLic,DrugManLic,DrugManLicDate,Gsp,GspDate,ImportEnrol,ImportEnrolDate,ImportLic,ImportLicDate,MatEnrol,
				// MatEnrolDate,MatManLic,MatManLicDate,MatPro,MatProDate,OrgCode,OrgCodeDate,Promises,ProPermit,ProPermitDate,RevReg,
				// RevRegDate,Sanitation,SanitationDate,TrustDeed,Quality,QualityDate,AgentLicDate,SalesName,SalesLicDate,SalesTel];

				var venArr=  [Code,Name,CategoryId,ConPerson,CtrlAcct,Address,Tel,ComLic,ComLicDate,RevReg,MatManLic,MatManLicDate,OrgCode,OrgCodeDate,MatPro,MatProDate,ProPermit,SalesLic,SalesLicDate,SalesName,SalesTel,CarrierTel];
	  			myData.length=myData.length+1;
				myData[myData.length-1]=venArr;		
				
				if (vp!="")
				{
					if (vendorPicFiles=="")
					{
						vendorPicFiles=Code+"$"+vp;
					}
					else
					{
						vendorPicFiles=vendorPicFiles+xRowDelim()+Code+"$"+vp	;
					}
				}
				//供应商Code+"$"+资质类型代码+
				
			}
			
			store1.loadData(myData);
		}
		catch(e)
		{
			alert('读取Excel文件供应商信息错误:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}
		
		// alert(vendorPicFiles);
		
		if (xlApp) xlApp=null;
		if (xlsheet) xlsheet=null;
		if (xlBook) {xlBook.Close(savechanges=false);}
	 }
	 
	/*导入或更新供应商*/
	function UpdVendor(result_str)
	{
		var url="dhcstm.apcvendoraction.csp?actiontype=ImpVendorFromExcel";
		Ext.Ajax.request({
			url:url,
			params:{vendorStr:result_str,
					vendorPicPath:vendor_pic_path,
					vendorPicFiles:vendorPicFiles
					},
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
		
	
	/*导入或更新厂商*/	
	function UpdManf(result_str)
	{
		var url="dhcstm.apcvendoraction.csp?actiontype=ImpManfFromExcel";
		Ext.Ajax.request({
			url:url,
			params:{manfStr:result_str},
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
	
	/*导入或者更新库存项目*/
	function UpdItm(result_str)
	{
		var url="dhcstm.apcvendoraction.csp?actiontype=ImpItmFromExcel";
		Ext.Ajax.request({
			url:url,
			params:{itmStr:result_str},
			success:function(result, request)
			{
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					if (name=="") 	{var info='导入库存项字典';}
					else  {var info='更新库存项字典';}
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

/*供应商图片code*/
function vendorPicCode(fname ) 
{
	var p1="营业执照";
	var p2="税务登记证";
	var p3="组织机构代码证";
	var p4="医疗器械经营许可证";
	var p5="业务员授权书";
	var code="";
	
	if (fname.indexOf(p1)>=0) {code="comLic";return code;}
	if (fname.indexOf(p2)>=0) {code="taxLic";return code;}
	if (fname.indexOf(p3)>=0) {code="orgCode";return code;}
	if (fname.indexOf(p4)>=0) {code="insBusLic";return code;}
	if (fname.indexOf(p5)>=0) {code="salesLic";return code;}
	return code;
}

/*厂商图片code*/
function manfPicCode(fname ) 
{
	var p1="营业执照";
	var p2="税务登记证";
	var p3="组织机构代码证";
	var p4="生产许可证";

	var code="";
	 
	if (fname.indexOf(p1)>=0) {code="comLic";return code;}
	if (fname.indexOf(p2)>=0) {code="taxLic";return code;}
	if (fname.indexOf(p3)>=0) {code="orgCode";return code;}
	if (fname.indexOf(p4)>=0) {code="insProLic";return code;}
    return code;
	
}
				
/*物资图片code*/
function itmPicCode(fname ) 
{
	var p1="说明书";
	var p2="物资正面";	

	var code="";	
	if (fname.indexOf(p1)>=0) {code="DrugUse";return code;}
	if (fname.indexOf(p2)>=0) {code="productmaster";return code;}
	return code;
}

/*物资图片code*/
function mcsaPicCode(fname ) 
{
	var p1="注册证";
	var p2="一级代理组织机构代码";	
	var p3="一级代理营业执照";	
	var p4="一级代理税务登记证";
	var p5="一级代理授权书";	
	var p6="一级代理企业许可证";	
	
	var code="";	
	if (fname.indexOf(p1)>=0) {code="";return code;}
	if (fname.indexOf(p2)>=0) {code="";return code;}
	
	
	
	
	
	return code;
}



/*根据列名取出列号
用来从excel文件中取相应列cell的值
*/
function CellInd(cm,colName) 
{
	var ind=cm.findColumnIndex(colName);
	if (ind>=0) ind++;
	 return ind;	
	
}

/*取注册证号*/
function getRegNo(s)
{
	var p1=s.indexOf("第");
	var p2=s.indexOf("号");
	var s1=s.substring(p1+1,p2-1)
	return s1
}


function searchFiles(path,picName){
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var f = fso.GetFolder(path);
    var fc = new Enumerator(f.files);
    var s = "";
	var result="";
	
	var pic=picName.substring(0,picName.indexOf("."));
	// alert(trim(pic));
    for (; !fc.atEnd(); fc.moveNext())
	{
		s =fc.item().Name;
		 var ind=s.lastIndexOf(trim(pic));
		if (ind>=0)
		{
			if (result=="") {result=s ;}
			else {result=result+"^"+s ;}
		}
	}
	return result
	// fk = new Enumerator(f.SubFolders);
	// for (; !fk.atEnd(); fk.moveNext())
	// {
	// s += fk.item();
	// s += "<br/>";
	// } 
}

function trim(str) {
  return str.replace(/(^\s+)|(\s+$)/g, "");
}

/*
 p  - 路径
 name - 
 type - 资质名称
*/
function picstr(p,name,type)
{
	var files=searchFiles(p,name);
	// alert(files);
	if (files!="")  {var s=type+"|"+files ; }
	else { var s="";}
	return s;
}

/*传进FTPX对象*/
function createFtp()
{
	var ftp = new ActiveXObject("FTP.FTPX");	
	return ftp;
}

/*使用FTPX对象上传文件*/
function ftpTransFile(serverIp,User,Pass,Port,LocalFile,ftpFileName)
{
   var ret=FTPX.FTP(serverIp,User,Pass,Port,LocalFile,ftpFileName);
   return ret
}

/*更新供应商资质图片*/
function UpdVendorPic(vpf)
{
 var xdelim=xRowDelim();
 var rows=vpf.split(xdelim);
 var rowCount=rows.length;
 for (var i=0;i<rowCount;i++)
 {
	 var row=rows[i];
	 var arr=row.split("$");
	 var code=arr[0];  //代码
	 var pics=arr[1];   // 图片串
	 var arr2=pics.split("!");
	 var picsCount=arr2.length;
	 for (var j=0;j<picsCount;j++)
	 {
		var pic=arr2[j] ; 	
		if (pic=="") {continue;};
		var arr3=pic.split("|");
		var type=arr3[0];
		var parr=arr3[1].split("^");
		for (var k=0;k<parr.length;k++)
		{
			var p=parr[k];			
			var picType=vendorPicCode(p) ;
			if (picType=="") 
			{	Msg.info("error","该文件无匹配的类型:"+p);
				return -3;
			}
			var localFile=vendor_pic_path+"\\"+code+"\\"+p ;
			var serverFile=ftpFileName();
			//上传文件
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//更新信息
				var ret=insVendorPic(code,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","更新供应商图片文件信息失败");
					return -2
				}
			}
			else{
				Msg.info("error","上传文件失败");
				return -1;
			}
		}			
	 }
 }	 	
}

/*更新厂商商资质图片*/
function updManfPic(mpf)
{
 var xdelim=xRowDelim();
 var rows=mpf.split(xdelim);
 var rowCount=rows.length;
 for (var i=0;i<rowCount;i++)
 {
	 var row=rows[i];
	 var arr=row.split("$");
	 var name=arr[0];  //厂商名称
	 var pics=arr[1];   // 图片串
	 var arr2=pics.split("!");
	 var picsCount=arr2.length;
	 for (var j=0;j<picsCount;j++)
	 {
		var pic=arr2[j] ; 	
		if (pic=="") {continue;};
		var arr3=pic.split("|");
		var type=arr3[0];
		var parr=arr3[1].split("^");
		for (var k=0;k<parr.length;k++)
		{
			var p=parr[k];			
			var picType=manfPicCode(p) ;
			if (picType=="") 
			{	Msg.info("error","无匹配的类型:"+p);
				return -1;
			}
			var localFile=manf_pic_path+"\\"+name+"\\"+p ;
			var serverFile=ftpFileName();
			//上传文件
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//更新信息
				var ret=insManfPic(name,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","更新厂商图片文件信息失败");
					return -2
				}
			}
			else
			{
				Msg.info("error","上传文件失败");
				return -1
			}
		}			
	 }
 }		
		
}

function updItmPic(ipf)
{
 var xdelim=xRowDelim();
 var rows=ipf.split(xdelim);
 var rowCount=rows.length;
 for (var i=0;i<rowCount;i++)
 {
	 var row=rows[i];
	 var arr=row.split("$");
	 var code=arr[0];  //代码名称
	 var pics=arr[1];   // 图片串
	 var arr2=pics.split("!");
	 var picsCount=arr2.length;
	 for (var j=0;j<picsCount;j++)
	 {
		var pic=arr2[j] ; 	
		if (pic=="") {continue;};
		var arr3=pic.split("|");
		var type=arr3[0];
		var parr=arr3[1].split("^");
		for (var k=0;k<parr.length;k++)
		{
			var p=parr[k];			
			var picType=itmPicCode(p) ;
			if (picType=="") 
			{	Msg.info("error","无匹配的类型:"+p);
				return -1;
			}
			var localFile=itm_pic_path+"\\"+code+"\\"+p ;
			var serverFile=ftpFileName();
			//上传文件
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//更新信息
				var ret=insItmPic(code,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","更新厂商图片文件信息失败");
					return -2
				}
			}
			else
			{
				Msg.info("error","上传文件失败");
				return -1
			}
		}			
	 }
 }			
	
	
}

/*更新授权资质图片*/
function updSaPic(sapf)
{
	
 var xdelim=xRowDelim();
 var rows=ipf.split(xdelim);
 var rowCount=rows.length;
 for (var i=0;i<rowCount;i++)
 {
	 var row=rows[i];
	 var arr=row.split("$");
	 var code=arr[0];  //代码名称
	 var pics=arr[1];   // 图片串
	 var arr2=pics.split("!");
	 var picsCount=arr2.length;
	 for (var j=0;j<picsCount;j++)
	 {
		var pic=arr2[j] ; 	
		if (pic=="") {continue;};
		var arr3=pic.split("|");
		var type=arr3[0];
		var parr=arr3[1].split("^");
		for (var k=0;k<parr.length;k++)
		{
			var p=parr[k];			
			var picType=itmPicCode(p) ;
			if (picType=="") 
			{	Msg.info("error","无匹配的类型:"+p);
				return -1;
			}
			var localFile=supply_authoriz_path+"\\"+code+"\\"+p ;
			var serverFile=ftpFileName();
			//上传文件
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//更新信息
				var ret=insItmPic(code,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","更新厂商图片文件信息失败");
					return -2
				}
			}
			else
			{
				Msg.info("error","上传文件失败");
				return -1
			}
		}			
	 }
 }				
}

/*取新文件名*/
function ftpFileName()
{
	var no="";
	var url="dhcstm.ftpcommon.csp?actiontype=NewFileName";
	var ss=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode( ss );
	if (jsonData.info!="") {		
		no=jsonData.info+".jpg";
	}
	return no;
}

/*ftp配置*/
function ftpConfig()
{
    var UserId = session['LOGON.USERID'];
	var LocId=session['LOGON.CTLOCID'];
	var GroupId=session['LOGON.GROUPID'];
	var url="dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId="+GroupId+"&LocId="+LocId+"&UserId="+UserId;
	var ss=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode( ss );
	if (jsonData.info!="") {
		var arr=jsonData.info.split("^");
		ftpServerIp=arr[0];
		ftpUser=arr[1];
		ftpPass=arr[2];
		ftpPort=arr[4];
		// alert(ftpPort) ;		
	} 
}

/*记录供应商资质信息
   return :
       0 - success
	   <0 - failure
*/
function insVendorPic(vendorCode,fileName,type)
{
	var url="dhcstm.apcvendoraction.csp?actiontype=InsVendorPic&vendorCode="+vendorCode+"&fileName"+fileName+"&type="+type;
	var ss=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode( ss );
	if (jsonData.success=="false")
	{
		Msg.info('error',"更新错误") ;
		return -2;
	}
	return 0
}
/*记录厂商资质信息
   return :
       0 - success
	   <0 - failure
*/
function insManfPic(manf,fileName,type)
{
	var url="dhcstm.phmanfaction.csp?actiontype=InsManfPic&manfName="+manf+"&fileName"+fileName+"&type="+type;
	var ss=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode( ss );
	if (jsonData.success=="false")
	{
		Msg.info('error',"更新错误") ;
		return -2;
	}
	return 0	
}

/*插入产品资质信息*/
function insItmPic(code,fileName,type)
{
	var url="dhcstm.druginfomaintainaction.csp?actiontype=InsItmPic&code="+code+"&fileName"+fileName+"&type="+type;
	var ss=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode( ss );
	if (jsonData.success=="false")
	{
		Msg.info('error',"更新错误") ;
		return -2;
	}
	return 0	
	
}


Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var xpanel = new Ext.form.FormPanel({
		frame:true,
		region:'north',
		height:50,
		title:'供应商相关信息批量更新',
		tbar:[tpath,pathName,'-',tReadFile,'-',t1,'-',t2]
    });

    var mainPanel = new Ext.ux.Viewport({
        layout:'border',			
        items:[xpanel,{split:true,region:'center',layout:'border',items:[gridVendorX,gridManfX]},gridIncItmX],
		renderTo:'mainPanel'
    });
	

	
	if (home_path=="") return;
	
	


});

