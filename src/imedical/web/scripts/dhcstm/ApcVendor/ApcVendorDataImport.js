 
 /*��Ӧ�����ݵ���*/
var cmVenX;
var cmManfX;
var cmIncItmX;

var vendorCodeStr="";  //��Ӧ�̴��봮("^"�ָ�)
var manfNameStr="";  //�������ƴ�("^"�ָ�)
var itmCodeStr="" ;  //���봮
var regNoStr=""  //ע��֤�Ŵ�

var home_path="";
var FTPX;

var ftpServerIp="";
var ftpUser="";
var ftpPass="";
var ftpPort="";

var home_path="E:\\GZ-�����ĵ�\\Customer\\TRYYNQ-ͬ��ҽԺ����\\��Ӧ�����ݵ���\\ʾ������";

/*ȫ�ֱ���*/
var vendorPicFiles="";
var manfPicFiles="";
var itmPicFiles="";
var saPicFiles="";
		
var vendor_pic_path=home_path+"\\"+"��Ӧ��ͼƬ";
var manf_pic_path=home_path+"\\"+"��������ͼƬ";
var supply_authoriz_path=home_path+"\\"+"��Ȩ����ͼƬ";
var itm_pic_path=home_path+"\\"+"����ͼƬ"


var vendor_data_file=home_path+"\\"+"��Ӧ���ֵ��.xls";
var manf_data_file=home_path+"\\"+"���������ֵ��.xls";
var itm_data_file=home_path+"\\"+"���������ֵ��.xls";
 

 // /*��Ӧ�������ļ�����*/
// function vendor_pic_filename(filename) 
// {
	// var fn=home_path+"/"+vendor_pic_path+"/"+filename;
	// return fn;
// }

 // /*�������������ļ�����*/
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
	// fieldLabel:'�����ļ���·��',
	// allowBlank:true,
	listWidth:300,
	width:300,
	value:'E:\\vendor\\',
	// anchor:'90%',
	selectOnFocus:true
});


	/* 	����������	
		�����̼���	
		����������	
		�����˺�	
		��ַ		
		�����绰	
		Ӫҵִ��	
		Ӫҵִ��Ч��	
		˰��Ǽ�֤	
		ҽ����е��Ӫ���֤	
		ҽ����е��Ӫ���֤Ч��	
		��֯��������֤	
		��֯��������Ч��	
		ҽ����е�������֤	
		ҽ����е�������֤Ч��	
		I��������ɵǼǱ�	
		ҵ��Ա��Ȩ��	
		ҵ��Ա��Ȩ����Ч��	
		ҵ��Ա����	
		ҵ��Ա�ֻ�����	
		�����ֻ����� */
	
	cmVenX=new Ext.grid.ColumnModel(
		[{header:'�����̴���',dataIndex:'Code'},  //����
		{header:'����������',dataIndex:'Name'},
		{header:'�����̼���',dataIndex:'CategoryId'},
		{header:'����������',dataIndex:'ConPerson'},	
		{header:'�����˺�',dataIndex:'CtrlAcct'},
		{header:'��ַ',dataIndex:'Address'},		
		{header:'�����绰',dataIndex:'Tel'},		
		{header:'Ӫҵִ��',dataIndex:'ComLic'},
		{header:'Ӫҵִ��Ч��',dataIndex:'ComLicDate'},		
		{header:'˰��Ǽ�֤',dataIndex:'RevReg'},
		{header:'ҽ����е��Ӫ���֤',dataIndex:'MatManLic'},
		{header:'ҽ����е��Ӫ���֤Ч��',dataIndex:'MatManLicDate'},	
		{header:'��֯��������֤',dataIndex:'OrgCode'},
		{header:'��֯��������Ч��',dataIndex:'OrgCodeDate'},	
		{header:'ҽ����е�������֤',dataIndex:'MatPro'},
		{header:'ҽ����е�������֤Ч��',dataIndex:'MatProDate'},	
		{header:'I��������ɵǼǱ�',dataIndex:'ProPermit'},		
		{header:'ҵ��Ա��Ȩ��',dataIndex:'SalesLic'},   //����
		{header:'ҵ��Ա��Ȩ����Ч��',dataIndex:'SalesLicDate'},
		{header:'ҵ��Ա����',dataIndex:'SalesName'},
		{header:'ҵ��Ա�ֻ�����',dataIndex:'SalesTel'},
		{header:'�����ֻ�����',dataIndex:'CarrierTel'}		
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
	������������	
	�������ҷ���	
	Ӫҵִ��	
	Ӫҵִ��Ч��	
	��֯��������֤	
	��֯��������֤Ч��	
	˰��Ǽ�֤	
	ҽ����е������Ӫ���֤	
	ҽ����е������Ӫ���֤Ч��	
	I��������ɵǼǱ� 
	*/
	
	cmManfX = new Ext.grid.ColumnModel([
	    {header:'������������',dataIndex:'Name'}, 
		{header:'�������ҷ���',dataIndex:'CategoryId'},  //����
	    {header:'Ӫҵִ��',dataIndex:'ComLic'},
	    {header:'Ӫҵִ��Ч��',dataIndex:'ComLicExp'},	
	    {header:'��֯��������֤',dataIndex:'OrgCode'},
	    {header:'��֯��������֤Ч��',dataIndex:'OrgCodeExpDate'},		
	    {header:'˰��Ǽ�֤',dataIndex:'TaxRegNo'},		
	    {header:'ҽ����е������Ӫ���֤',dataIndex:'MatPermit'},
	    {header:'ҽ����е������Ӫ���֤Ч��',dataIndex:'MatPermitExp'},	
	    {header:'I��������ɵǼǱ�',dataIndex:'ProPermitRegForm'} //����	
	  
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
	����״̬˵��	
	ͬ����	
	������	
	�����̼۸�	
	�����	
	�����	
	��ۼ۸�	
	�շѱ�־	
	����	
	����ͺ�	
	������	
	��Ʒ���	
	һ���Ա�־	
	Ʒ��	
	��λ	
	��С�ͻ���λ	
	���͵绰(�ֻ�)	
	����(����)��־	
	ҽ����еע��֤��	
	ҽ����еע��֤ͼƬ	
	�洢����	
	��(ʡ)��	
	��ֵ���־	
	ֲ���־	
	Ч�ڳ���(��)	
	�Ƿ�����������˵����	
	����ʹ��˵����	
	����ͼƬ	
	�����������(��)	
	���������ʽ	
	ҽ����еע��֤��ֹ����	
	��������	
	һ��������Ȩ��	
	һ��������ȨЧ��	
	һ������˾����	
	һ������˾����ͼƬ	
	����������Ȩ��	
	����������ȨЧ��	
	��������˾����	
	��������˾����ͼƬ	
	����������Ȩ��	
	����������ȨЧ��	
	��Ӧ������	
	����¼����	
	¼������ϵ�绰	 
	*/																																																																																																																																																																																																														
	
	cmIncItmX = new Ext.grid.ColumnModel([
	    {header:'����״̬˵��',dataIndex: 'NotUse'}, 
	    {header:'ͬ����',dataIndex: 'TongRenCode'}, 
	    {header:'������',dataIndex: 'Abbre'}, 
	    {header:'�����̼۸�',dataIndex: 'Rp'}, 
	    {header:'�����',dataIndex: 'PriceCode'}, 
	    {header:'�����',dataIndex: 'PriceDesc'}, 
	    {header:'��ۼ۸�',dataIndex: 'Sp'}, 
	    {header:'�շѱ�־',dataIndex: 'ChargeFlag'}, 
	    {header:'����',dataIndex: 'Desc'}, 
	    {header:'����ͺ�',dataIndex: 'Spec'}, 
		{header:'������',dataIndex: 'SpecList'}, 
		{header:'��Ʒ���',dataIndex: 'Cat'}, 	  
		{header:'һ���Ա�־',dataIndex: 'BAFlag'}, 
		{header:'Ʒ��',dataIndex: 'Brand'}, 	  
		{header:'��λ',dataIndex: 'UOM'}, 
		{header:'��С�ͻ���λ',dataIndex: 'PUOM'}, 	  
		{header:'���͵绰(�ֻ�)',dataIndex: 'CarrTel'}, 
		{header:'����(����)��־',dataIndex: 'ImportFlag'}, 	  
		{header:'ҽ����еע��֤��',dataIndex: 'RegNo'}, 
		{header:'ҽ����еע��֤ͼƬ',dataIndex: 'RegNoPicName'}, 	  
		{header:'�洢����',dataIndex: 'StorageCon'}, 
		{header:'��(ʡ)��',dataIndex: 'ComFrom'}, 	  
		{header:'��ֵ���־',dataIndex: 'HighPrice'}, 
		{header:'ֲ���־',dataIndex: 'ImplantFlag'}, 	  
		{header:'Ч�ڳ���(��)',dataIndex: 'ExpireLen'}, 
		{header:'�Ƿ�����������˵����',dataIndex: 'DrugUseFlag'}, 	  
		{header:'����ʹ��˵����',dataIndex: 'DrugUse'}, 
		{header:'����ͼƬ',dataIndex: 'PackFilePath'}, 	  
		{header:'�����������(��)',dataIndex: 'SterileDateLen'}, 
		{header:'���������ʽ',dataIndex: 'SterileCat'}, 	  
		{header:'ҽ����еע��֤��ֹ����',dataIndex: 'RegNoExpDate'}, 
		{header:'��������',dataIndex: 'Manf'}, 	  
		{header:'һ��������Ȩ��',dataIndex: 'OneLevelAgentLic'}, 
		{header:'һ��������ȨЧ��',dataIndex: 'OneLevelAgentLicExp'}, 	  
		{header:'һ������˾����',dataIndex: 'OneLevelAgentName'}, 
		{header:'һ������˾����ͼƬ',dataIndex: 'OneLevelAgentQual'}, 	  
		{header:'����������Ȩ��',dataIndex: 'TwoLevelAgentLic'}, 
		{header:'����������ȨЧ��',dataIndex: 'TwoLevelAgentLicExp'}, 	  
		{header:'��������˾����',dataIndex: 'TwoLevelAgentName'}, 
		{header:'��������˾����ͼƬ',dataIndex: 'TwoLevelAgentQual'}, 	  
		{header:'����������Ȩ��',dataIndex: 'ThreeLevelAgentLic'}, 
		{header:'����������ȨЧ��',dataIndex: 'ThreeLevelAgentLicExp'}, 	  
		{header:'��Ӧ������',dataIndex: 'VendorName'}, 
		{header:'����¼����',dataIndex: 'VendorUser'}, 	  
		{header:'¼������ϵ�绰',dataIndex: 'VendorUserTel'}
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
		title:'1 -��Ӧ����Ϣ',
		cm:cmVenX,
		height:200,
		split:true,
	    store:store1,
		region:'north'
		});
	
	var gridManfX=new Ext.grid.GridPanel({
		title:'2 -������Ϣ',
		cm:cmManfX,
		split:true,
		store:store2,
		region:'center'
	})
 	
	var gridIncItmX=new Ext.grid.GridPanel({
		title:'3 -�����ֵ���Ϣ',
		cm:cmIncItmX,
		store:store3,
		split:true,
		height:200
		,
		region:'south'
	})
	var tpath=new Ext.Toolbar.Button({
		text:'�����ļ���·��:'
	});
	var tReadFile=new Ext.Toolbar.Button({
		text:'��ȡ����',
		iconCls:'page_edit',
		id:'Read',
		handler:function()
		{
			ReadFromExcel();
		}
	});
	
	var t1=new Ext.Toolbar.Button({
		text:'ִ�и���',
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
		text:'ȡ��',
		id:'cacelBt',
		iconCls:'page_edit',
		handler:function()
		{
			win.close();
		}
	});
	
	

	/*��ȡ��Ӧ������*/
	function ReadFromExcel()
	{
		// var Template=fileName;
		// var xlApp = new ActiveXObject("Excel.Application");
		// var xlBook = xlApp.Workbooks.Add(Template);	
		// var xlsheetVendor = xlBook.Worksheets(1) ;	//���¹�Ӧ��
		// var xlsheetManf = xlBook.Worksheets(2) ;	 //���³���
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
		var xlsheet = xlBook.Worksheets(1) ;	//���³���
		
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
					
				//if (Code==""){Msg.info("error","���̴��벻��Ϊ��,�����ļ�!");Ext.getCmp("update").setDisabled(true);}
				var ind=CellInd(cmManfX,"Name");
				var Name="";
				if (ind>0)  {
					Name =vStr(xlsheet.Cells(i,ind).value); 
				}
				
				//if (Name==""){Msg.info("error","�������Ʋ���Ϊ��,�����ļ�!");Ext.getCmp("update").setDisabled(true);}
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
				
				if (Code==""){Code=Name;}   //������������ 
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
			alert('��ȡExcel�ļ�������Ϣ����:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}				
		
	}
	
	function ReadItmFromExcel(fileName)
	{
		var Template=fileName;
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);	
		var xlsheet = xlBook.Worksheets(1) ;	//���¹�Ӧ��		
		if (!xlApp)	{return;}
	 	ItmExcelData="";		
		
		var startRow=2;
		var myData3 = [];
		var ip="";
		var sap="" ; //��Ȩ��
		
		try{
			for (var i=startRow;i<1000;i++)
			{
				var result_str="";
				var ind=CellInd(cmIncItmX,"NotUse");    //����״̬˵��
				if (ind>0) { NotUse=vStr(xlsheet.Cells(i,ind).value);					}
					
				var ind=CellInd(cmIncItmX,"TongRenCode");  //ͬ����
				var TongRenCode="";
				if (ind>0)  {
					TongRenCode =vStr(xlsheet.Cells(i,ind).value); 
				}
				var ind=CellInd(cmIncItmX,"Abbre");  //������
				Abbre=vStr(xlsheet.Cells(i,ind).value); 
				var ind=CellInd(cmIncItmX,"Rp");  //�����̼۸�
				var Rp	=vStr(xlsheet.Cells(i,ind).value);
				
				var ind=CellInd(cmIncItmX,"PriceCode"); //�����
				var PriceCode =vDate(xlsheet.Cells(i,ind).value);  
				
				var ind=CellInd(cmIncItmX,"PriceDesc"); //�����
				var PriceDesc =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Sp");  //��ۼ۸�
				var Sp  =vDate(xlsheet.Cells(i,ind).value);

				var ind=CellInd(cmIncItmX,"ChargeFlag");  //�շѱ�־
				var  ChargeFlag=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Desc");  //����
				var  Desc=vStr(xlsheet.Cells(i,ind).value);
				if (Desc=='') break;
				var ind=CellInd(cmIncItmX,"Spec");  //����ͺ�
				var  Spec=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"SpecList");  //������
				var  SpecList=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Cat");  //��Ʒ���
				var  Cat=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"BAFlag");  //һ���Ա�־
				var  BAFlag=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"Brand");  //Ʒ��
				var  Brand=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"UOM");  //��λ
				var  UOM=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"PUOM");  //��С�ͻ���λ
				var  PUOM=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"CarrTel");  //���͵绰(�ֻ�)
				var CarrTel =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"ImportFlag");  //����(����)��־
				var ImportFlag =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"RegNo");  //ҽ����еע��֤��
				var  RegNo=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"RegNoPicName");  //ҽ����еע��֤ͼƬ
				var  RegNoPicName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"StorageCon");  //�洢����
				var  StorageCon=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"ComFrom");  //��(ʡ)��
				var  ComFrom=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"HighPrice");  //��ֵ���־
				var  HighPrice=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"ImplantFlag");  //ֲ���־
				var  ImplantFlag=vStr(xlsheet.Cells(i,ind).value);
				// alert('sss');
				var ind=CellInd(cmIncItmX,"ExpireLen");  //Ч�ڳ���(��)
				var  ExpireLen=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"DrugUseFlag");  //�Ƿ�����������˵����  ?????????????????????????????
				var DrugUseFlag =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"DrugUse");  //����ʹ��˵����
				var DrugUse =vStr(xlsheet.Cells(i,ind).value);
				if (DrugUse!="") 
				{	
					var pics=picstr(itm_pic_path+"\\"+TongRenCode,DrugUse,"DrugUse") ;
					if (ip=="") {ip=pics;}
					else {ip=ip+"!"+pics;}
				}
				var ind=CellInd(cmIncItmX,"PackFilePath");  //����ͼƬ
				var  PackFilePath=vStr(xlsheet.Cells(i,ind).value);
				if (PackFilePath!="") 
				{	
					var pics=picstr(itm_pic_path+"\\"+TongRenCode,PackFilePath,"productMaster") ;
					if (ip=="") {ip=pics;}
					else {ip=ip+"!"+pics;}
				}				

				var ind=CellInd(cmIncItmX,"SterileDateLen");  //�����������(��)
				var SterileDateLen =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"SterileCat");  //���������ʽ
				var SterileCat =vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"RegNoExpDate");  //ҽ����еע��֤��ֹ����
				var RegNoExpDate =vDate(xlsheet.Cells(i,ind).value);
				// alert('ttt');
				var ind=CellInd(cmIncItmX,"Manf");  //��������
				var Manf=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"OneLevelAgentLic");  //һ��������Ȩ��
				var OneLevelAgentLic =vStr(xlsheet.Cells(i,ind).value);
				
				if (OneLevelAgentLic!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,OneLevelAgentLic,"OneLevelAgentLic") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}		
				var ind=CellInd(cmIncItmX,"OneLevelAgentLicExp");  //һ��������ȨЧ��
				var OneLevelAgentLicExp =vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"OneLevelAgentName");  //һ������˾����
				var  OneLevelAgentName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"OneLevelAgentQual");  //һ������˾����ͼƬ
				var OneLevelAgentQual =vStr(xlsheet.Cells(i,ind).value);
				if (OneLevelAgentQual!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,OneLevelAgentQual,"OneLevelAgentQual") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}
				var ind=CellInd(cmIncItmX,"TwoLevelAgentLic");  //����������Ȩ��
				var TwoLevelAgentLic =vStr(xlsheet.Cells(i,ind).value);
				if (TwoLevelAgentLic!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,TwoLevelAgentLic,"TwoLevelAgentLic") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}	
				var ind=CellInd(cmIncItmX,"TwoLevelAgentLicExp");  //����������ȨЧ��
				var TwoLevelAgentLicExp=vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"TwoLevelAgentName");  //��������˾����
				var TwoLevelAgentName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"TwoLevelAgentQual");  //��������˾����ͼƬ
				var TwoLevelAgentQual=vStr(xlsheet.Cells(i,ind).value);
				if (TwoLevelAgentQual!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,TwoLevelAgentQual,"TwoLevelAgentQual") ;
					if (sap=="") {sap=pics;}
					else {sap=sap+"!"+pics;}
				}
				var ind=CellInd(cmIncItmX,"ThreeLevelAgentLic");  //����������Ȩ��
				var  ThreeLevelAgentLic=vStr(xlsheet.Cells(i,ind).value);
				if (ThreeLevelAgentLic!="") 
				{	
					var pics=picstr(supply_authoriz_path+"\\"+TongRenCode,ThreeLevelAgentLic,"ThreeLevelAgentLic") ;
					if (sap=="") {sap=pics;}
				}	
				var ind=CellInd(cmIncItmX,"ThreeLevelAgentLicExp");  //����������ȨЧ��
				var ThreeLevelAgentLicExp =vDate(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"VendorName");  //��Ӧ������
				var  VendorName=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"VendorUser");  //����¼����
				var  VendorUser=vStr(xlsheet.Cells(i,ind).value);
				var ind=CellInd(cmIncItmX,"VendorUserTel");  //¼������ϵ�绰
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
			alert('��ȡExcel�ļ�������Ϣ����:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}			
	}
	
	 function ReadVendorFromExcel(fileName)
	 {
		var Template=fileName;
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);	
		var xlsheet = xlBook.Worksheets(1) ;	//���¹�Ӧ��
		
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
				var code=vStr(xlsheet.Cells(i,ind).value);	//��Ӧ�̴���
				if (code=="") break;
				if (code==""){Msg.info("error","��Ӧ�̴��벻��Ϊ��,�����ļ�!!");Ext.getCmp("update").setDisabled(true);}
				var ind=CellInd(cmVenX,'Name');
				var name=vStr(xlsheet.Cells(i,ind).value);	//��Ӧ������
				if (name==""){Msg.info("error","��Ӧ�����Ʋ���Ϊ��,�����ļ�!!");Ext.getCmp("update").setDisabled(true);}
				
				var ind=CellInd(cmVenX,'Tel');
				var tel	=vStr(xlsheet.Cells(i,ind).value);	//��Ӧ�̵绰
				
				var ind=CellInd(cmVenX,'ConPerson');
				var contact	=vStr(xlsheet.Cells(i,ind).value);	//������
				var ind=CellInd(cmVenX,'CtrlAcct');
				var account	=vStr(xlsheet.Cells(i,ind).value);	//�˺�
				// var purchaseAmtLtd	=vStr(xlsheet.Cells(i,6).value);	//�ɹ��޶�
				var ind=CellInd(cmVenX,'CategoryId');
				var cats=vStr(xlsheet.Cells(i,ind).value);	//��Ӧ�̷���
				
				// var contractenddate	=vDate(xlsheet.Cells(i,8).value);	//��ͬ��ֹ����
				// var fax	=vStr(xlsheet.Cells(i,9).value);	//����
				// var legal_representative	=vStr(xlsheet.Cells(i,10).value);	//���˴���
				
				var ind=CellInd(cmVenX,'Address');				
				var address	=vStr(xlsheet.Cells(i,ind).value);	//��ַ
				
				var ind=CellInd(cmVenX,'ComLic');			
				var comLic	=vStr(xlsheet.Cells(i,ind).value);//	����ִ��
				if (comLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,comLic,"comLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+xRowDelim()+pics;}
				}
				
				var ind=CellInd(cmVenX,'ComLicDate');			
				var comLic_ExpDate	=vDate(xlsheet.Cells(i,ind).value);	//����ִ����Ч��
				var ind=CellInd(cmVenX,'RevReg');			
				var taxLic	=vStr(xlsheet.Cells(i,ind).value);	//˰��Ǽ�
				if (taxLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,taxLic,"taxLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				
				// var taxLic_ExpDate	=vDate(xlsheet.Cells(i,15).value);	//˰��Ǽ�Ч��
	
				var ind=CellInd(cmVenX,'MatManLic');			
				var insBusLic=vStr(xlsheet.Cells(i,ind).value);//	ҽ����е��Ӫ���֤
				if (insBusLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,insBusLic,"insBusLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'MatManLicDate');			
				var insBusLic_ExpDate=vDate(xlsheet.Cells(i,ind).value);	//Ч��
				var ind=CellInd(cmVenX,'ProPermit');	
				var proPermit=vStr(xlsheet.Cells(i,ind).value);  //���������Ͽɱ�	

				// var proPermit_ExpDate=vDate(xlsheet.Cells(i,19).value);  //Ч��	 			
				// var insRegLic	=vStr(xlsheet.Cells(i,20).value);	//ҽ����еע��֤
				// var insRegLic_ExpDate=vDate(xlsheet.Cells(i,21).value);	//	Ч��
				// var hygLic=vStr(xlsheet.Cells(i,22).value);	//	�������֤
				// var hygLic_ExpDate=vDate(xlsheet.Cells(i,23).value);		//Ч��
				
				var ind=CellInd(cmVenX,'OrgCode');	
				var orgCode	=vStr(xlsheet.Cells(i,ind).value);	//��֯��������
				if (orgCode!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,orgCode,"orgCode") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'OrgCodeDate');	
				var orgCode_ExpDate	=vDate(xlsheet.Cells(i,ind).value);	//Ч��
				// var Gsp	=vStr(xlsheet.Cells(i,26).value);	//Gsp
				// var Gsp_ExpDate	=vDate(xlsheet.Cells(i,27).value);	//GspЧ��

				var ind=CellInd(cmVenX,'MatPro');			
				var insProLic=vStr(xlsheet.Cells(i,ind).value);	//	��е�������֤
				if (insProLic!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,insProLic,"insProLic") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'MatProDate');	
				var insProLic_ExpDate=vDate(xlsheet.Cells(i,ind).value);	//	Ч��	
				
				// var inletRLic	=vStr(xlsheet.Cells(i,30).value);	//����ҽ����еע��֤
				// var inletRLic_ExpDate=vDate(xlsheet.Cells(i,31).value);//	Ч��	
				// var inletRegLic	=vStr(xlsheet.Cells(i,32).value);	//����ע��ǼǱ�
				// var inletRegLic_ExpDate	=vDate(xlsheet.Cells(i,33).value);//	Ч��
				// var agentAuth	=vStr(xlsheet.Cells(i,34).value);	//����������Ȩ��
				// var agentAuth_ExpDate=vDate(xlsheet.Cells(i,35).value);	//	Ч��
				// var serviceComm	=vStr(xlsheet.Cells(i,36).value);//�ۺ�����ŵ��
				// var legalComm	=vStr(xlsheet.Cells(i,37).value);	//	����ί����
				// var qualityComm	=vStr(xlsheet.Cells(i,38).value);//������ŵ��
				// var qualityComm_ExpDate	=vDate(xlsheet.Cells(i,39).value);	//������ŵ����Ч��
				
				var ind=CellInd(cmVenX,'SalesName');	
				var salesmanName	=vStr(xlsheet.Cells(i,ind).value);	//ҵ��Ա����
				var ind=CellInd(cmVenX,'SalesLic');	
				var salesmanAuth	=vStr(xlsheet.Cells(i,ind).value);	//ҵ��Ա��Ȩ��
				if (salesmanAuth!="") 
				{	
					var pics=picstr(vendor_pic_path+"\\"+code,salesmanAuth,"salesmanAuth") ;
					if (vp=="") {vp=pics;}
					else {vp=vp+"!"+pics;}
				}
				var ind=CellInd(cmVenX,'SalesLicDate');	
				var salesmanAuth_ExpDate	=vDate(xlsheet.Cells(i,ind).value);//	ҵ��Ա��Ȩ����Ч��
				var ind=CellInd(cmVenX,'SalesTel');
				var salesmanTel=vStr(xlsheet.Cells(i,ind).value);	//ҵ��Ա�绰
				var ind=CellInd(cmVenX,'CarrierTel');
				var CarrierTel=vStr(xlsheet.Cells(i,ind).value);  //���͵绰
				
				var result_str="";
				var Code=code;   //(1)
				var Name=name;  //(2)
				var Tel=tel;  //(3)
				var ConPerson=contact;//(4)
				var CtrlAcct=account ;//(5)
				// var CrLimit= purchaseAmtLtd ;//(6)		
				// var Fax=fax ; //(7)
				// var President= legal_representative ;//(8) -���˴���
				// var PresidentId="";	//(9)  -���˴������֤��
				// var Status="" ;//(10)
				// result_str=Code+"^"+Name+"^"+Tel+"^"+ConPerson+"^"+CtrlAcct+"^"+CrLimit+"^"+Fax+"^"+President+"^"+PresidentId+"^"+Status;
				var CategoryId=cats ;//(11)
				
				// var CrAvail="" ;  //(12)  -ע���ʽ�
				// var LstPoDate=contractenddate ; //(13)  -��ͬ��������
				var Address=address;  //(14)
				// var RCFlag="";  //(15)
				var ComLic=comLic  ;//(16)
				var ComLicDate=comLic_ExpDate ; //(17)
				// var AgentLic=agentAuth ; //(18)
				// var DrugManLic="" ; //(19)   ҩƷ��Ӫ���֤
				// var DrugManLicDate="" ;  //(20) ҩƷ��Ӫ���֤Ч��
				// result_str=result_str+"^"+CategoryId+"^"+CrAvail+"^"+LstPoDate+"^"+Address+"^"+RCFlag+"^"+ComLic+"^"+ComLicDate+"^"+AgentLic+"^"+DrugManLic+"^"+DrugManLicDate;
				// var Gsp=Gsp;  // (21)
				// var GspDate=Gsp_ExpDate ; //(22)	
				// var ImportEnrol=inletRLic ; //(23)
				// var ImportEnrolDate=inletRLic_ExpDate;  //(24)
				// var ImportLic=inletRegLic;//(25)
				// var ImportLicDate=inletRegLic_ExpDate ;//(26)
				// var MatEnrol=insRegLic  ; //(27)   - ҽ����еע��֤
				// var MatEnrolDate=insRegLic_ExpDate ;   //(28)
				var MatManLic=insBusLic ;//(29)  - ҽ����е��Ӫ���֤
				var MatManLicDate=insBusLic_ExpDate; //(30)		
				// result_str=result_str+"^"+Gsp+"^"+GspDate+"^"+ImportEnrol+"^"+ImportEnrolDate+"^"+ImportLic+"^"+ImportLicDate+"^"+MatEnrol+"^"+MatEnrolDate+"^"+MatManLic+"^"+MatManLicDate;
				var MatPro=insProLic;  //(31) - ��е�������֤
				var MatProDate=insProLic_ExpDate ; //(32)
				var OrgCode=orgCode ; // (33)
				var OrgCodeDate=orgCode_ExpDate;  // (34)	
				// var Promises=serviceComm;  //(35)  - �ۺ�����ŵ��
				var ProPermit=proPermit ;//(36)   - ����������ɱ�
				// var ProPermitDate=proPermit_ExpDate;   //(37)
				var RevReg=taxLic;   //(38) -˰��ǼǺ�
				// var RevRegDate=taxLic_ExpDate ;  //(39)
				// var Sanitation=hygLic ; //(40)  -�������֤
				// result_str=result_str+"^"+MatPro+"^"+MatProDate+"^"+OrgCode+"^"+OrgCodeDate+"^"+Promises+"^"+ProPermit+"^"+ProPermitDate+"^"+RevReg+"^"+RevRegDate+"^"+Sanitation;
				// var SanitationDate=hygLic_ExpDate;//(41)
				// var TrustDeed=legalComm;  //(42)  -����ί����
				// var Quality=qualityComm ; //(43)
				// var QualityDate=qualityComm_ExpDate ; //(44)
				// var AgentLicDate=agentAuth_ExpDate ; //(45)  -������Ȩ��Ч��
				
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
				//��Ӧ��Code+"$"+�������ʹ���+
				
			}
			
			store1.loadData(myData);
		}
		catch(e)
		{
			alert('��ȡExcel�ļ���Ӧ����Ϣ����:'+e);
			closeFile(xlApp,xlBook,xlsheet);
		}
		
		// alert(vendorPicFiles);
		
		if (xlApp) xlApp=null;
		if (xlsheet) xlsheet=null;
		if (xlBook) {xlBook.Close(savechanges=false);}
	 }
	 
	/*�������¹�Ӧ��*/
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
		
	
	/*�������³���*/	
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
	
	/*������߸��¿����Ŀ*/
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
					if (name=="") 	{var info='���������ֵ�';}
					else  {var info='���¿�����ֵ�';}
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

/*��Ӧ��ͼƬcode*/
function vendorPicCode(fname ) 
{
	var p1="Ӫҵִ��";
	var p2="˰��Ǽ�֤";
	var p3="��֯��������֤";
	var p4="ҽ����е��Ӫ���֤";
	var p5="ҵ��Ա��Ȩ��";
	var code="";
	
	if (fname.indexOf(p1)>=0) {code="comLic";return code;}
	if (fname.indexOf(p2)>=0) {code="taxLic";return code;}
	if (fname.indexOf(p3)>=0) {code="orgCode";return code;}
	if (fname.indexOf(p4)>=0) {code="insBusLic";return code;}
	if (fname.indexOf(p5)>=0) {code="salesLic";return code;}
	return code;
}

/*����ͼƬcode*/
function manfPicCode(fname ) 
{
	var p1="Ӫҵִ��";
	var p2="˰��Ǽ�֤";
	var p3="��֯��������֤";
	var p4="�������֤";

	var code="";
	 
	if (fname.indexOf(p1)>=0) {code="comLic";return code;}
	if (fname.indexOf(p2)>=0) {code="taxLic";return code;}
	if (fname.indexOf(p3)>=0) {code="orgCode";return code;}
	if (fname.indexOf(p4)>=0) {code="insProLic";return code;}
    return code;
	
}
				
/*����ͼƬcode*/
function itmPicCode(fname ) 
{
	var p1="˵����";
	var p2="��������";	

	var code="";	
	if (fname.indexOf(p1)>=0) {code="DrugUse";return code;}
	if (fname.indexOf(p2)>=0) {code="productmaster";return code;}
	return code;
}

/*����ͼƬcode*/
function mcsaPicCode(fname ) 
{
	var p1="ע��֤";
	var p2="һ��������֯��������";	
	var p3="һ������Ӫҵִ��";	
	var p4="һ������˰��Ǽ�֤";
	var p5="һ��������Ȩ��";	
	var p6="һ��������ҵ���֤";	
	
	var code="";	
	if (fname.indexOf(p1)>=0) {code="";return code;}
	if (fname.indexOf(p2)>=0) {code="";return code;}
	
	
	
	
	
	return code;
}



/*��������ȡ���к�
������excel�ļ���ȡ��Ӧ��cell��ֵ
*/
function CellInd(cm,colName) 
{
	var ind=cm.findColumnIndex(colName);
	if (ind>=0) ind++;
	 return ind;	
	
}

/*ȡע��֤��*/
function getRegNo(s)
{
	var p1=s.indexOf("��");
	var p2=s.indexOf("��");
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
 p  - ·��
 name - 
 type - ��������
*/
function picstr(p,name,type)
{
	var files=searchFiles(p,name);
	// alert(files);
	if (files!="")  {var s=type+"|"+files ; }
	else { var s="";}
	return s;
}

/*����FTPX����*/
function createFtp()
{
	var ftp = new ActiveXObject("FTP.FTPX");	
	return ftp;
}

/*ʹ��FTPX�����ϴ��ļ�*/
function ftpTransFile(serverIp,User,Pass,Port,LocalFile,ftpFileName)
{
   var ret=FTPX.FTP(serverIp,User,Pass,Port,LocalFile,ftpFileName);
   return ret
}

/*���¹�Ӧ������ͼƬ*/
function UpdVendorPic(vpf)
{
 var xdelim=xRowDelim();
 var rows=vpf.split(xdelim);
 var rowCount=rows.length;
 for (var i=0;i<rowCount;i++)
 {
	 var row=rows[i];
	 var arr=row.split("$");
	 var code=arr[0];  //����
	 var pics=arr[1];   // ͼƬ��
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
			{	Msg.info("error","���ļ���ƥ�������:"+p);
				return -3;
			}
			var localFile=vendor_pic_path+"\\"+code+"\\"+p ;
			var serverFile=ftpFileName();
			//�ϴ��ļ�
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//������Ϣ
				var ret=insVendorPic(code,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","���¹�Ӧ��ͼƬ�ļ���Ϣʧ��");
					return -2
				}
			}
			else{
				Msg.info("error","�ϴ��ļ�ʧ��");
				return -1;
			}
		}			
	 }
 }	 	
}

/*���³���������ͼƬ*/
function updManfPic(mpf)
{
 var xdelim=xRowDelim();
 var rows=mpf.split(xdelim);
 var rowCount=rows.length;
 for (var i=0;i<rowCount;i++)
 {
	 var row=rows[i];
	 var arr=row.split("$");
	 var name=arr[0];  //��������
	 var pics=arr[1];   // ͼƬ��
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
			{	Msg.info("error","��ƥ�������:"+p);
				return -1;
			}
			var localFile=manf_pic_path+"\\"+name+"\\"+p ;
			var serverFile=ftpFileName();
			//�ϴ��ļ�
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//������Ϣ
				var ret=insManfPic(name,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","���³���ͼƬ�ļ���Ϣʧ��");
					return -2
				}
			}
			else
			{
				Msg.info("error","�ϴ��ļ�ʧ��");
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
	 var code=arr[0];  //��������
	 var pics=arr[1];   // ͼƬ��
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
			{	Msg.info("error","��ƥ�������:"+p);
				return -1;
			}
			var localFile=itm_pic_path+"\\"+code+"\\"+p ;
			var serverFile=ftpFileName();
			//�ϴ��ļ�
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//������Ϣ
				var ret=insItmPic(code,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","���³���ͼƬ�ļ���Ϣʧ��");
					return -2
				}
			}
			else
			{
				Msg.info("error","�ϴ��ļ�ʧ��");
				return -1
			}
		}			
	 }
 }			
	
	
}

/*������Ȩ����ͼƬ*/
function updSaPic(sapf)
{
	
 var xdelim=xRowDelim();
 var rows=ipf.split(xdelim);
 var rowCount=rows.length;
 for (var i=0;i<rowCount;i++)
 {
	 var row=rows[i];
	 var arr=row.split("$");
	 var code=arr[0];  //��������
	 var pics=arr[1];   // ͼƬ��
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
			{	Msg.info("error","��ƥ�������:"+p);
				return -1;
			}
			var localFile=supply_authoriz_path+"\\"+code+"\\"+p ;
			var serverFile=ftpFileName();
			//�ϴ��ļ�
			if (ftpTransFile(ftpServerIp,ftpUser,ftpPass,ftpPort,localFile,serverFile)==0 )
			{
				//������Ϣ
				var ret=insItmPic(code,serverFile,picType) ;
				if (ret<0)
				{
					Msg.info("error","���³���ͼƬ�ļ���Ϣʧ��");
					return -2
				}
			}
			else
			{
				Msg.info("error","�ϴ��ļ�ʧ��");
				return -1
			}
		}			
	 }
 }				
}

/*ȡ���ļ���*/
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

/*ftp����*/
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

/*��¼��Ӧ��������Ϣ
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
		Msg.info('error',"���´���") ;
		return -2;
	}
	return 0
}
/*��¼����������Ϣ
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
		Msg.info('error',"���´���") ;
		return -2;
	}
	return 0	
}

/*�����Ʒ������Ϣ*/
function insItmPic(code,fileName,type)
{
	var url="dhcstm.druginfomaintainaction.csp?actiontype=InsItmPic&code="+code+"&fileName"+fileName+"&type="+type;
	var ss=ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode( ss );
	if (jsonData.success=="false")
	{
		Msg.info('error',"���´���") ;
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
		title:'��Ӧ�������Ϣ��������',
		tbar:[tpath,pathName,'-',tReadFile,'-',t1,'-',t2]
    });

    var mainPanel = new Ext.ux.Viewport({
        layout:'border',			
        items:[xpanel,{split:true,region:'center',layout:'border',items:[gridVendorX,gridManfX]},gridIncItmX],
		renderTo:'mainPanel'
    });
	

	
	if (home_path=="") return;
	
	


});

