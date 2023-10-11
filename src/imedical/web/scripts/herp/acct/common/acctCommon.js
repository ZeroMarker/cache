// /����: ȫ�ֱ��������÷�������
// /����: ȫ�ֱ��������÷�������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.21

var PageSize = 30;
var RowDelim=String.fromCharCode(1);  //�����ݼ�ķָ���
var FieldDelim="^";  //�ֶμ�ķָ���

Ext.lib.Ajax.getConnectionObject = function() {
	var activeX = ['MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP'];
	function createXhrObject(transactionId) {
		var http;
		try {
			http = new XMLHttpRequest();
		} catch (e) {
			for (var i = 0; i < activeX.length; ++i) {
				try {
					http = new ActiveXObject(activeX[i]);
					break;
				} catch (e) {
				}
			}
		} finally {
			return {
				conn : http,
				tId : transactionId
			};
		}
	}

	var o;
	try {
		if (o = createXhrObject(Ext.lib.Ajax.transactionId)) {
			Ext.lib.Ajax.transactionId++;
		}
	} catch (e) {
	} finally {
		return o;
	}
};

if(document.addEventListener){
		document.addEventListener("keydown",maskBackspace, true);
	}else{
		document.attachEvent("onkeydown",maskBackspace);
}	

/**
 * ִ�����ݿ�ͬ������
 * @param {} url ����·��
 * @return {}
 */
ExecuteDBSynAccess = function(url) {
	var conn = Ext.lib.Ajax.getConnectionObject().conn;
	conn.open("POST", url, false);
	conn.send();
	return conn.responseText;
};

/**
 * ����Ĭ����Ա
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogUser = function(store, CmpName) {
	// ��¼����Ĭ��ֵ
	var rowId = session['LOGON.USERID'];
	var name = session['LOGON.USERNAME'];
	var defaultData = {
		RowId : rowId,
		Description : name
	};
	var record = new store.recordType(defaultData);
	store.add(record);
	Ext.getCmp(CmpName).setValue(rowId);
};

/**
 * ���õ�¼����
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogInDept = function(store, CmpName) {
	// ��¼����Ĭ��ֵ
	var rowId = session['LOGON.CTLOCID'];
//	var arr = window.status.split(":");
//	var length = arr.length;
//	var name = arr[length-1];
	var defaultData = {
		RowId : rowId,
		Description : App_LogonLocDesc
	};
	var record = new store.recordType(defaultData);
	store.add(record);
	Ext.getCmp(CmpName).setValue(rowId);
};

/**
 * ΪComboBox��ֵ
 * ������id������Ҫ��RowIdһ��(Ŀǰ�����л�������String)
 */
function addComboData(store, id, desc) {
	if(store.findExact('RowId',id)==-1){
		var defaultData = {
			RowId : id,
			Description : desc
		};
		var r = new store.recordType(defaultData);
		store.add(r);
	}
}

/**
 * ����dateindexȡgrid��index
 */
function GetColIndex(grid,dateIndex){
	var columnModel=grid.getColumnModel();
	var index=-1;
	if(columnModel){
		index=columnModel.findColumnIndex(dateIndex);
	}
	
	return index;
}

function ShowLoadMask(target,msg){
 var mk = new Ext.LoadMask(target, {
	msg: msg,
	removeMask: true //��ɺ��Ƴ�
 });
 
 mk.show();
 return mk;
}

/**
 * ������������֮����������,������ʽ����ΪY-m-d
 */
function DaysBetween(dateFrom,dateTo){
	//һ��ĺ�����
	var oneDay=24*60*60*1000   
	
	//����������ת��Ϊ������
	var dateFrom_ms=Date.parse(dateFrom.replace(/-/g,"/"));   //dateFrom.getTime();  	
	var dateTo_ms=Date.parse(dateTo.replace(/-/g,"/"));   //dateTo.getTime();
	
	//// Calculate the difference in milliseconds
	var dateDiff_ms=Math.abs(dateTo_ms-dateFrom_ms);
	var dateDiff=Math.round(dateDiff_ms/oneDay); 
	
	return dateDiff;
}

/**
 * �����ڸ�ʽ���ַ���ת����Date����
 */
function toDate(value){
	if(value==null || value==''){
		return value;
	}
	if(Ext.isDate(value)==true){
		return value;
	}
	var newValue=value;
	if(typeof value=='string'){
		if(value.indexOf('-')){
			value=value.replace(/-/g,"/");
			var newValue=new Date(Date.parse(value));
			//newValue=newValue.format('Y-m-d');
		}
	}
	
	return newValue;
}

 //���α༭ҳ����BackSpace��
function maskBackspace(event){
	var event = event || window.event; //
	var obj = event.target || event.srcElement;
	var keyCode = event.keyCode ? event.keyCode : event.which ?
		event.which : event.charCode;
	if(keyCode == 8){
	if(obj!=null && obj.tagName!=null && (obj.tagName.toLowerCase() == "input" || obj.tagName.toLowerCase() == "textarea"))
	{
		event.returnValue = true ;
		if(Ext.getCmp(obj.id)){
			if(Ext.getCmp(obj.id).readOnly || (Ext.getCmp(obj.id).getXType()=='combo' &&  Ext.getCmp(obj.id).editable==false) ) {
				if(window.event)
					event.returnValue = false ; //or event.keyCode=0
				else
					event.preventDefault(); //for ff[/b]
			}
		}
	}else{
		if(window.event)
			event.returnValue = false ; // or event.keyCode=0
		else
			event.preventDefault();   //[/b] //for ff
	}
	}
}


 //����ȡ��ע�����ֶ�ʱ����ע��֮����趨�ָ���$c(3) 
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return realkey;
}

//�Ժ�̨���صı�ע�ֶμ��Դ���-��ʹ�ûس����з� $c(13,10) �滻$c(3)
function handleMemo(memo,token) 
{
	var xx='';
 	var ss=memo.split(token);
 	for (var i=0;i<ss.length;i++)
 	{
 		if (xx=='') {xx=ss[i];}
 		else
 		{xx=xx+'\n\r'+ss[i];}
 	}
	return xx	
}

function xRowDelim(){
	var realkey  = String.fromCharCode(1);  
	return realkey;	

}

 function DecimalFormat(value,decimalLen){
		//����������ֵĻ�ԭֵ����
		if(/^\d*\.{0,1}\d*$/.test(value)==false){
			return value;
		}
		
		var newValue=Number(value).toFixed(decimalLen);
		return newValue;
}

//�ϲ�ĳ������ͬ��������
function cellMerge(value, meta, record, rowIndex, colIndex, store,fieldName) {
    var first = !rowIndex || value !== store.getAt(rowIndex - 1).get(fieldName),
    last = rowIndex >= store.getCount() - 1 || value !== store.getAt(rowIndex + 1).get(fieldName);
    meta.css += 'row-span' + (first ? ' row-span-first' : '') +  (last ? ' row-span-last' : '');
    if (first) {
        var i = rowIndex + 1;
        while (i < store.getCount() && value === store.getAt(i).get(fieldName)) {
            i++;
        }
        var rowHeight = 20, padding = 6,
            height = (rowHeight * (i - rowIndex) - padding) + 'px';
        meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
    }
    return first ? value : '';
}

/*  ����grid�е����ݵ�excel�ļ� 
 *  Ҫ��
 *     ���������ִ��ActiveX�ؼ�
 * 
 * */
function gridSaveAsExcel(grid)
{
  	if (grid.getStore().getCount()==0)
	{
		Msg.info('warning','û����Ҫ��������ݣ�');
		return;
	};  

    var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	
	// ��������MaxFileSize. �������
	fd.MaxFileSize = 32767;
	// ��ʾ�Ի���
	fd.ShowSave();
	var fileName=fd.FileName;
	if (fileName=='') return;
	//
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		Msg.info("warning","���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�");
		return "";
	}
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(fso.FileExists(fileName)){
		var fileArr=fileName.split("\\");
		var fileDesc=fileArr[fileArr.length-1];
		if(confirm('�ļ�"'+fileDesc+'"�Ѿ����ڣ��Ƿ��滻ԭ���ļ���')==false){
		 	xlApp.Quit(); 
			xlApp=null;
			return;
		}
	}
	
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	
	var cm=grid.getColumnModel();
	var colCount=cm.getColumnCount();
	var temp_obj=[];

	/*for (i=1;i<colCount;i++)
	{
		if (cm.isHidden(i) ==true)
		{}
		else
		{
			temp_obj.push(i);  //ֻ��û�����ص���
		}
	}*/
	
	for (i=1;i<colCount;i++)
	{	
			temp_obj.push(i);  //��ʾ���е��У��������ص���  2015.8.18	
	}

	//Excel��һ�д�ű���
	for (l=1;l<=temp_obj.length;l++)
	{
		xlSheet.Cells(1,l).Value=cm.getColumnHeader(temp_obj[l-1]);
	}

	var store=grid.getStore();
	var recordCount=store.getCount();
	var view=grid.getView();
	for (k=1;k<=recordCount;k++)
	{
		for (j=1;j<=temp_obj.length;j++)
		{
			var cellValue=view.getCell(k-1,temp_obj[j-1]).innerText;
			//�ж��Ƿ����ָ�ʽ,����"001"������"1"
			var regExpPattern=/^(-?\d*)(.?\d*)$/;
			if(cellValue!="" && regExpPattern.test(cellValue)){
				xlSheet.Cells(k+1,j).Value="\'"+cellValue;	//ȫ����ת�����ַ���
			}else{
				xlSheet.Cells(k+1,j).Value=cellValue;
			}
		}
	}
	try
	{
		var ss = xlBook.SaveAs(fileName);  
		if (ss==false)
		{
			Msg.info('error','���ʧ�ܣ�') ;
		}
	}
	catch(e){
		Msg.info('error','���ʧ�ܣ�') ;
	}

 	xlApp.Quit(); 
	xlApp=null;
	xlBook=null;
	xlSheet=null;
 	   
}
/*  ����store�е����ݵ�excel�ļ� 
 *  Ҫ��
 *     ���������ִ��ActiveX�ؼ�
 * 
 * */
function StoreSaveAsExcel(store,cm)
{
  	if (store.getCount()==0)
	{
		Msg.info('warning','û����Ҫ��������ݣ�');
		return;
	};  
    var fd;
    fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	
	// ��������MaxFileSize. �������
	fd.MaxFileSize = 32767;
	// ��ʾ�Ի���
	fd.ShowSave();
	var fileName=fd.FileName;
	if (fileName=='') return;
	//
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		Msg.info("warning","���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�");
		return "";
	}
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(fso.FileExists(fileName)){
		var fileArr=fileName.split("\\");
		var fileDesc=fileArr[fileArr.length-1];
		if(confirm('�ļ�"'+fileDesc+'"�Ѿ����ڣ��Ƿ��滻ԭ���ļ���')==false){
		 	xlApp.Quit(); 
			xlApp=null;
			return;
		}
	}
	
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	var colCount=cm.getColumnCount();
	var temp_obj=[];
	var arr_obj=[];  ///���ԭʼrecord����name

	for (i=1;i<colCount;i++)
	{
		if (cm.isHidden(i) ==true)
		{}
		else
		{
			temp_obj.push(i);  //ֻ��û�����ص���
		}
	}
	var temrecord=store.getAt(0)
	for (m in temrecord.data)
	{
		arr_obj.push(m);  //��ԭʼ����
	}
	//Excel��һ�д�ű���
	for (l=0;l<arr_obj.length;l++)
	{
		for (n=0;n<temp_obj.length;n++)
		{
			if(arr_obj[l]==cm.getDataIndex(temp_obj[n]))
			{
				xlSheet.Cells(1,l+1).Value=cm.getColumnHeader(temp_obj[n]);
			}
		}
	}
	
	var recordCount=store.getCount();
	for (k=0;k<recordCount;k++)
	{
		var arrrecord=store.getAt(k)
		for (j=0;j<arr_obj.length;j++)
		{
			var indexname=arr_obj[j]
			xlSheet.Cells(k+2,j+1).Value=arrrecord.get(indexname)
		}
	}
	try
	{
		var ss = xlBook.SaveAs(fileName);  
		if (ss==false)
		{
			Msg.info('error','���ʧ�ܣ�') ;
		}		
	}
	catch(e){
		Msg.info('error','���ʧ�ܣ�') ;
	}

 	xlApp.Quit(); 
	xlApp=null;
	xlBook=null;
	xlSheet=null;
 	   
}
/** ��ҳ��������Execl�������� **/
function ExportAllToExcel(gridPanel) {
    if (gridPanel) {
        var tmpStore = gridPanel.getStore();
       
        //���´����ҳgrid���ݵ��������⣬�ӷ������л�ȡ�������ݣ���Ҫ��������
        var tmpParam = tmpStore.lastOptions //�˴���¡��ԭ��������Դ�Ĳ�����Ϣ

        if (tmpParam && tmpParam.params) {
            tmpParam.params[tmpStore.paramNames.start]=0; //
            tmpParam.params[tmpStore.paramNames.limit]=999999; //���÷�ҳ��Ϣ
        }
        var tmpAllStore = new Ext.data.GroupingStore({//���¶���һ������Դ
            proxy: tmpStore.proxy,
            reader: tmpStore.reader
        });
        tmpAllStore.on('load', function (store) {
            StoreSaveAsExcel(store,gridPanel.getColumnModel())
        });
        tmpAllStore.load(tmpParam); //��ȡ��������
    }
};

function SetFieldOriginal(field){
	if(field.items!=null){
		field.items.each(function(subField){
			SetFieldOriginal(subField);
		});
	}else{
		field.originalValue=String(field.getValue());
	}
}

///���ñ���ʼֵ, �ڲ�ѯ���ر���Ϣ֮�����
///panel:�����ڵ�panel����
function SetFormOriginal(panel){
	var panelId=panel.getId();
	Ext.getCmp(panelId).getForm().items.each(function(f){
		SetFieldOriginal(f);
	});
}

///�жϱ��Ƿ����ı�
///return: true, false
function IsFormChanged(panel){
	var panelId=panel.getId();
	var isMainChanged=Ext.getCmp(panelId).getForm().isDirty();
	return isMainChanged;
}

/*ʹEnter����Tab��ִ��
 * 
 * */
function setEnterTab(panel)
{
	panel.getForm().items.each(function(f){
		f.on('specialkey',function(id,e){
			var keyCode=e.getKey();
			if(keyCode==e.ENTER)
			{				
				var evt = (event)?event:window.event;
				var element=evt.srcElement || evt.target;
				
				var isIe = (document.all) ? true : false;
				if (isIe)  //IE������Ĵ���
				{
					if (evt.srcElement.nodeName != "TEXTAREA" && evt.srcElement.type != "submit")
						evt.keyCode=9;
				}
				else  ///��IE������Ĵ���Ŀǰ��ȱ
				{ 
				
				}			   
			}		
		})
	})
}

 ///���panel�µ�item��ֵ
function clearPanel(panel)
{
	var i=0;
	var p=Ext.getCmp(panel);
	if (p) {
		var pp = p.items;
		var cnt = pp.getCount();
		
		for (var i=0;i<cnt;i++) {
			var xtype = pp.item(i).getXType();
//			alert(xtype);
			if (xtype) {
				if ((xtype == 'textfield') || (xtype == 'datefield') || (xtype == 'numberfield') || (xtype == 'textarea') || (xtype == 'timefield')) {
					pp.item(i).setValue('');
				}
				if (xtype == 'combo') {
					pp.item(i).clearValue();
				}
				
				if ((xtype == 'checkbox') || (xtype == 'radio')) {
					pp.item(i).setValue(false);
				}
				
				if (xtype=='panel') {
					var panelId=pp.item(i).getId();
					if (panelId) {clearPanel(panelId);//�˴��ݹ�
					}
				}
			}
		}
	}
}

///����Ext.form.ComboBox��¼���ֵ�Ƿ���ƥ������У���ֵƥ�䣬����ֵ��Ϊ�ա�	
///�˺����ʺ�����combobox������ڽ����뿪ʱ����֤���ж�
function chkInputOfCombo(cb) 
{
	var store=cb.getStore();
	var displayField=cb.displayField;
	var valueField=cb.valueField;
	var inputs=cb.getRawValue();
	
	var ind=store.findExact(displayField,inputs,0,false,false);
	
	if (ind>-1)
	{
		var rec=store.getAt(ind);
		var value=rec.get(valueField);

		cb.setValue(value);
	}
	else{
		cb.clearValue();
	}
}

///���ݿ��ҵı仯,�޸�����comboȡֵ
///input:	����combo
function GetSCGbyLoc(locCombo,scgCombo){
	var loc=locCombo.getValue();
	scgCombo.setValue('');
	var scgStore=scgCombo.getStore();
	scgStore.removeAll();
	scgStore.setBaseParam('type',App_StkTypeCode);
	scgStore.setBaseParam('locId',loc);
	scgStore.setBaseParam('userId',session['LOGON.USERID']);
	scgStore.load({
		callback:function(r,options,success){
			if(success==true){
				scgCombo.fireEvent('change');
			}
		}
	});
}
