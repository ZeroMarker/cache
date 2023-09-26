// /名称: 全局变量及常用方法定义
// /描述: 全局变量及常用方法定义
// /编写者：zhangdongmei
// /编写日期: 2012.08.21
var DHCSTBlankBackGround="../csp/dhcst.blank.backgroud.csp"; //ext+润乾默认显示的报表背景
var PageSize = 30;
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
var FieldDelim="^";  //字段间的分隔符
var gParamCommon=[];
var gGrantStkGrp="";
var idTmr="";
var HospId=session['LOGON.HOSPID'];
// IE11判断 Ext.isIE11
Ext.apply(Ext, ((a = navigator.userAgent) && /Trident/.test(a) && /rv:11/.test(a)) ? {isIE11:true, ieVersion: 11} : {});
// 去掉fieldLabel的冒号
Ext.apply(Ext.form.Field.prototype,{labelSeparator:""});
// grid 行数列宽度
Ext.grid.RowNumberer.prototype.width = 30;

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
 * 执行数据库同步访问
 * @param {} url 访问路径
 * @return {}
 */
ExecuteDBSynAccess = function(url) {
	var conn = Ext.lib.Ajax.getConnectionObject().conn;
	conn.open("POST", url, false);
	conn.send();
	return conn.responseText.trim();
};

/**
 * 设置默认人员
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogUser = function(store, CmpName) {
	// 登录设置默认值
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
 * 设置登录科室
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogInDept = function(store, CmpName) {
	// 登录设置默认值
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
 * 为ComboBox赋值
 */
function addComboData(store, id, desc) {
	if(store.getById(id)==undefined){
		var defaultData = {
			RowId : id,
			Description : desc
		};
		var r = new store.recordType(defaultData);
		//store.removeAll();
		store.add(r);
	}
}

/**
 * 根据dateindex取grid列index
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
	removeMask: true //完成后移除
 });
 
 mk.show();
 return mk;
}

/**
 * 计算两个日期之间间隔的天数,参数格式必须为Y-m-d
 */
function DaysBetween(dateFrom,dateTo){
	//一天的毫秒数
	var oneDay=24*60*60*1000   
	
	//将两个日期转换为毫秒数
	var dateFrom_ms=Date.parse(dateFrom.replace(/-/g,"/"));   //dateFrom.getTime();  	
	var dateTo_ms=Date.parse(dateTo.replace(/-/g,"/"));   //dateTo.getTime();
	
	//// Calculate the difference in milliseconds
	var dateDiff_ms=Math.abs(dateTo_ms-dateFrom_ms);
	var dateDiff=Math.round(dateDiff_ms/oneDay); 
	

	return dateDiff;
}

/**
 * 将日期格式的字符串转换成Date类型
 */
function toDate(value){
	var dhcstdatefmt=App_StkDateFormat.toUpperCase();
	if(value==null || value==''){
		return value;
	}
	if(Ext.isDate(value)==true){
		return value;
	}
	var newValue=value;
	if(typeof value=='string'){
		if(value.indexOf('-')>=0){
			value=value.replace(/-/g,"/");
			var newValue=new Date(Date.parse(value));
		}else if((value.indexOf('/')>=0)&&(dhcstdatefmt.indexOf("/")>=0)){
			var tmpDate=value.split(" ")[0];
			var tmpTime=value.split(" ")[1];
			if (tmpTime==undefined){
				tmpTime="";
			}
			var datefmtarr=dhcstdatefmt.split("/");
			var tmpD=datefmtarr.indexOf("D");
			var tmpM=datefmtarr.indexOf("M");
			var tmpY=datefmtarr.indexOf("Y");
			var tmpDateArr=tmpDate.split("/");
			var tmpNewDate=tmpDateArr[tmpY]+"/"+tmpDateArr[tmpM]+"/"+tmpDateArr[tmpD]
		    tmpNewDate=tmpNewDate+" "+tmpTime;
			var newValue=new Date(Date.parse(tmpNewDate));
		}
	}
	
	return newValue;
}

 //屏蔽编辑页面上BackSpace键
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


 //返回取备注类型字段时，备注行之间的设定分隔符$c(3) 
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return realkey;
}

//对后台返回的备注字段加以处理-即使用回车换行符 $c(13,10) 替换$c(3)
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
		//如果不是数字的话原值返回
		if (isNaN(value)==true){
			return value;
		}
		//if(/^\d*\.{0,1}\d*$/.test(value)==false){
		//	return value;
		//}
		
		var newValue=Number(value).toFixed(decimalLen);
		return newValue;
}

//合并某列中相同的行数据
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


/*  LiangQiang 2014-09-02*/
function gridSaveAsExcel(grid)
{
  	if (grid.getStore().getCount()==0)
	{
		Msg.info('warning','没有需要保存的数据！');
		return;
	};  
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return "";
	}
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	
	var cm=grid.getColumnModel();
	var colCount=cm.getColumnCount();
	var temp_obj=[];

	for (i=1;i<colCount;i++)
	{
		if (cm.isHidden(i) ==true)
		{}
		else
		{
			temp_obj.push(i);  //只存没有隐藏的列
		}
	}

	//Excel第一行存放标题
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
			xlSheet.Cells(k+1,j).Value=view.getCell(k-1,temp_obj[j-1]).innerText;
		}
	} 	   
	try
	{
		var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
 		var ss = xlBook.SaveAs(fileName);  
	 	if (ss==false)
		{
			Msg.info('error','另存失败！') ;
		}		
	}
	catch(e){
		 Msg.info('error','另存失败！') ;
	}


	xlSheet=null;
    xlBook.Close (savechanges=false);
    xlBook=null;
    xlApp.Quit();
    xlApp=null;
	window.setInterval("Cleanup();",1);
 	   
}

function SetFieldOriginal(field){
	if(field.items!=null){
		field.items.each(function(subField){
			SetFieldOriginal(subField);
		});
	}else{
		field.originalValue=String(field.getValue());
	}
}

///设置表单初始值, 在查询返回表单信息之后调用
///panel:表单所在的panel名称
function SetFormOriginal(panel){
	var panelId=panel.getId();
	Ext.getCmp(panelId).getForm().items.each(function(f){
		SetFieldOriginal(f);
	});
}

///判断表单是否发生改变
///return: true, false
function IsFormChanged(panel){
	var panelId=panel.getId();
	var isMainChanged=Ext.getCmp(panelId).getForm().isDirty();
	return isMainChanged;
}

/*使Enter键按Tab键执行*/
function setEnterTab(panel)
{
	panel.getForm().items.each(function(f){
		f.on('specialkey',function(id,e){
			var keyCode=e.getKey();
			if(keyCode==e.ENTER)
			{
			window.event.keyCode=9; }
		})
	})

}

 

/*
 * creator:wyx,2014-03-13
 * description:取参数配置公共模块界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return:
     进价小数位数(入库单位)^批价小数位数(入库单位)^售价小数位数(入库单位)^进价金额小数位数
      ^批价金额小数位数^售价金额小数位数^集团化标志^进价规则^库存数量小数位数^类组设置
*/ 

function GetParamCommon(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcst.commonparamconfig.csp?actiontype=GetParamCommon&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gParamCommon=info.split('^');
		}
	}

	return;
}
/*
 * creator:wyx,2014-04-28
 * description:取登录人员所被授权的所有类组以“^”连接
 * params: 
 * return:被授权的所有类组以“^”连接
*/
function GetGrantStkGrp(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url=DictUrl+ 'extux.csp?actiontype=GetGrantStkGrp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gGrantStkGrp=info;
		}
	}

	return;
}


function Cleanup() //清除打印后遗留死进程 lq 2007-10-12
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}

/**保存store中的数据到excel文件 
 * 要求:浏览器允许执行ActiveX控件
 * yunhaibao,20151230,每次写入一行数据,提高导出速度
 */
function StoreSaveAsExcel(store,cm,fileName){
    if (store.getCount()==0){
      Msg.info('warning','没有需要保存的数据！');
      return;
  };
  var titleObj={};
  var temp_obj=[];	//存放需要导出的columns

  var temp_obj=cm.getColumnsBy(function(c){
      return !(c.hidden || c.dataIndex=="");
  });
  // Excel第一行存放标题	
  for (var n=0;n<temp_obj.length;n++){
      var temp_obj_n=temp_obj[n];
      var tmpHeader=temp_obj_n.header.replace(/<\/?[^>]*>/g,'');
      var tmpIndex=temp_obj_n.dataIndex 
      titleObj[tmpIndex]=tmpHeader
  }
  // 格式化数据
  var rowsData=[];
  var recordCount=store.getCount();
  for (var k=0;k<recordCount;k++){
      var colobj=[];
      var arrRecord=store.getAt(k);
      var rowData={};
      for (var j=0;j<temp_obj.length;j++){
          var colDataIndex=temp_obj[j].dataIndex;
          var cellValue=arrRecord.get(colDataIndex);
          // 单位,厂家等信息需要如下操作
          if (cellValue=="NULL"){cellValue=""}
          var colRenderer=cm.getRenderer(cm.getIndexById(temp_obj[j].id));
          
          if(Ext.isFunction(colRenderer)&&temp_obj[j].xtype!="checkcolumn"){
              try{
                  if (colRenderer(cellValue,j,arrRecord,k,j,store)){
                        var newcellValue=colRenderer(cellValue,j,arrRecord,k,j,store);
                        if ((newcellValue.indexOf("span")<0)&&(newcellValue.indexOf("check")<0)&&(newcellValue.indexOf("<a")<0)){
                            cellValue=newcellValue
                        }	
                  }
              }
              catch(e){
              }
          }
          if ((parseInt(cellValue)==cellValue)&&(cellValue!=0)){
              if (cellValue.toString().charAt(0)==0){
                  cellValue="'"+cellValue;
              }
          }
          rowData[colDataIndex]=cellValue;	
          
      }
      rowsData.push(rowData);
  }
  
  LoadJS(["../scripts/pha/com/v1/js/export.js"],function(){
      PHA_EXPORT.XLSX(titleObj,rowsData,fileName);
  });
  
  return;
  // 下方为原始导出
  try{
      var fso = new ActiveXObject("Scripting.FileSystemObject");
      var sTextfile = fso.CreateTextFile(fileName,true,true)
      var colCount=cm.getColumnCount();
      var temp_obj=[];	//存放需要导出的columns
      var arr_obj=[];		//存放原始record所有name

      var temp_obj=cm.getColumnsBy(function(c){
          return !(c.hidden || c.dataIndex=="");
      });
      //Excel第一行存放标题
      var tmpwriterecord="",tmpheader="",tmpheaderarr=[];
      var DelimCol=String.fromCharCode(9);	
      for (var n=0;n<temp_obj.length;n++){
          tmpheader=temp_obj[n].header.replace(/<\/?[^>]*>/g,'');
          if (tmpwriterecord=="") {tmpwriterecord=tmpheader;}
          else {tmpwriterecord=tmpwriterecord+DelimCol+tmpheader;}
          tmpheaderarr[n]=tmpheader;
      }
      sTextfile.WriteLine(tmpwriterecord)
      var recordCount=store.getCount();
      for (var k=0;k<recordCount;k++){
          var colobj=[];
          var arrRecord=store.getAt(k);
          tmpwriterecord=""
          for (var j=0;j<temp_obj.length;j++){
              var colDataIndex=temp_obj[j].dataIndex;
              var cellValue=arrRecord.get(colDataIndex);
              // 单位,厂家等信息需要如下操作
              if (cellValue=="NULL"){cellValue=""}
              var colRenderer=cm.getRenderer(cm.getIndexById(temp_obj[j].id));
              if(Ext.isFunction(colRenderer)&&temp_obj[j].xtype!="checkcolumn"){
                  try{
                      if (colRenderer(cellValue,j,arrRecord,k,j,store)){
                            var newcellValue=colRenderer(cellValue,j,arrRecord,k,j,store);
                            if ((newcellValue.indexOf("span")<0)&&(newcellValue.indexOf("check")<0)&&(newcellValue.indexOf("<a")<0)){
                                cellValue=newcellValue
                            }	
                      }
                  }
                  catch(e){
                  }
              }
              if ((parseInt(cellValue)==cellValue)&&(cellValue!=0)){
                  if (cellValue.toString().charAt(0)==0){
                      cellValue="'"+cellValue;
                  }
              }	
              if (tmpwriterecord==""){tmpwriterecord=cellValue;}
              else{tmpwriterecord=tmpwriterecord+DelimCol+cellValue;}	
          }
          
          sTextfile.WriteLine(tmpwriterecord)
      }
      store.destroy();
      sTextfile.Close();
         sTextfile=null;
      fso=null;	
      Msg.info('success',"另存成功!") ;
      window.setInterval("Cleanup();",1);	
  }
  catch(e){
      Msg.info('error',e.message) ;
  }  
}



/**分页导出所有Excel导出方法 
 * yunhaibao20151231,添加当无MSComDlg.CommonDialog权限时,前台提示是否写入注册表
 */
function ExportAllToExcel(gridPanel) {
	//if (isIE()){
	if (1==1){
		if (gridPanel) {
			var tmpStore = gridPanel.getStore();
			if (tmpStore.getCount()==0)
			{
				Msg.info('warning','没有需要保存的数据！');
				return;
			};
			//以下处理分页grid数据导出的问题，从服务器中获取所有数据，需要考虑性能
			var tmpParam = tmpStore.lastOptions //此处克隆了原网格数据源的参数信息
			if (tmpParam && tmpParam.params) {
				tmpParam.params[tmpStore.paramNames.start]=0;
				tmpParam.params[tmpStore.paramNames.limit]=999999; //重置分页信息
			}
			var tmpAllStore = new Ext.data.Store({	//重新定义一个数据源
				proxy: tmpStore.proxy,
				reader: tmpStore.reader
			});
			if (tmpStore.sortInfo){
				tmpParam.params["sort"]=tmpStore.sortInfo.field;
				tmpParam.params["dir"]=tmpStore.sortInfo.direction;
			}
			/*
			try{
    				
				var mscd = new ActiveXObject("MSComDlg.CommonDialog");
				mscd.Filter = "Microsoft Office Excel(*.xlsx)|*.xlsx";
				mscd.FilterIndex = 1;
				// 必须设置MaxFileSize. 否则出错
				mscd.MaxFileSize = 32767;
				// 显示对话框
				mscd.ShowSave();
				var fileName=mscd.FileName;
				mscd=null;
			}
			catch(e)
			{
					if (confirm("当前系统不支持创建路径,是否载入文件配置?\n载入成功后,重启浏览器生效!\n如重启后不生效请添加信任站点并注册scrrun.dll、COMDLG32.OCX！"))
					{
						var fso = new ActiveXObject("Scripting.FileSystemObject");
						var sTextfile = fso.CreateTextFile("C:\\MSCommonDialog.reg",true)
						sTextfile.WriteLine("Windows Registry Editor Version 5.00")
						sTextfile.WriteLine("[HKEY_CLASSES_ROOT\\Licenses\\4D553650-6ABE-11cf-8ADB-00AA00C00905]")
						sTextfile.WriteLine("@=\"gfjmrfkfifkmkfffrlmmgmhmnlulkmfmqkqj\"")
						sTextfile.Close();
	   					sTextfile=null;
	    				fso=null;
	    				var shell = new ActiveXObject("WScript.Shell"); 
	    				shell.Run("C:\\MSCommonDialog.reg");
	    				return;
	    					
					}
					else{
						return;					
					}
			}*/
			var fileName='数据导出_' + new Date().getTime() + '.xlsx'; 
			if (fileName=='') return;
			var loadMask=ShowLoadMask(document.body,"处理中...");
			tmpAllStore.on('load', function (store) {
				loadMask.hide();
				StoreSaveAsExcel(store,gridPanel.getColumnModel(),fileName)
				
			});
			tmpAllStore.load(tmpParam); //获取所有数据
		}
	}
	else{
		try{
			ExportForDataBrowser.DownloadByUrl(gridPanel, "");
		}
		catch(e){
			alert(e.message)
		}
	}
};

/**
 * 设置回车跳转的顺序
 * @param {} grid 
 * @param {} proIndexName
 */
function setEnterSort(grid,colArr) {
	var addRowFlag=true;
	//if(window.event.keyCode!=13){return false;}  //yunhaibao20161129注释
	if(colArr.length<=0) return;
	var cel=grid.getSelectionModel().getSelectedCell()
	var indexName=grid.getColumnModel().getDataIndex(cel[1]);
	for(var i=0; i<colArr.length;i++){
		var tempcol = colArr[i];
		if(tempcol.dataIndex==indexName){
			if(i<colArr.length-1){
				var nextIndex=colArr[i+1].dataIndex
				var cell = grid.getSelectionModel().getSelectedCell();
				var col=GetColIndex(grid,nextIndex);
				grid.startEditing(cell[0], col);
				addRowFlag=false;
			}
			else{
				var currentcol=GetColIndex(grid,indexName);
				grid.stopEditing(cel[0], currentcol);
			}
		}
	}
	return addRowFlag;
}
/**
 * 初始化跳转顺序,不走配置形式
 * @param {} grid
 * @return {}
 * nosortarr为预留参数,传入的数组不参与跳转
 */
function sortColoumByEnter(grid,nosortarr){
	if ((nosortarr==undefined)||(nosortarr==null)){
		nosortarr=""
	}
	var columnModel=grid.getColumnModel();
	var colArr=[];
	for(var a=0; a<columnModel.getColumnCount();a++){
		var col=grid.getColumnModel().config[a];
		if(col.hidden) {
			continue;
		}
		if (nosortarr!=""){
			if(nosortarr.indexOf(col.dataIndex)>=0){
				continue;
			}
		}
		if (col.editor==null)  //不可编辑不进行跳转
		{
		   continue;
		}
		colArr.push(col)
	}
	//按enterSort进行排序
	colArr.sort(function(obj1,obj2){
            return obj1.enterSort-obj2.enterSort});
	return colArr;
}
/**
 * 初始化跳转顺序
 * @param {} grid
 * @return {}
 */
function sortColoumByEnterSort(grid){
	var columnModel=grid.getColumnModel();
	var colArr=[];
	for(var a=0; a<columnModel.getColumnCount();a++){
		var col=grid.getColumnModel().config[a];
		if(col.hidden) {
			continue;
		}
		if(col.enterSort>0){
			colArr.push(col)
		}
	}
	//按enterSort进行排序,yunhaibao20170718,目前用不上,没看懂
	//colArr.sort(function(obj1,obj2){
    //        return obj1.enterSort-obj2.enterSort});
	return colArr;
} 

/**
 * 实例化record
 * 简化record实例化代码,返回实例化的record
 * @param {} RecordObject	:Record结构,可以用store.fields
 * @param {} NewRecord		:特殊赋值,形如{fieldA:valueA,fieldB:valueB,...}
 * 							该值传入"",null,{},或者不传,都可以
 * 例如库存调整中:var NewRecord=CreateRecordInstance(INAdjMGridDs.fields);
 */
function CreateRecordInstance(RecordObject,SpecialValue){
	SpecialValue = SpecialValue||{};
	var record = new Ext.data.Record.create(RecordObject);
	var NewRecord = new record(SpecialValue);
	for(var n=0;n<RecordObject.items.length;n++){
		var tmpField=RecordObject.items[n];
		if(NewRecord.data[tmpField.name]==undefined){
			//这里是set空,还是set缺省值呢?
			NewRecord.set(tmpField.name,tmpField.defaultValue);
		}
	}
	return NewRecord;
}

 //判断是否是IE,仅IE支持ActiveXObject
function isIE() {   
    if (!!window.ActiveXObject || "ActiveXObject" in window) { 
    	return true;
    }  
    else{
	    return false;
	} 
}
/*
 * creator:yunhaibao
 * createdate: 2015-11-27
 * description:针对data协议浏览器的导出
 * others:超长问题尚未解决,几百条数据还行
 * params: 
*/
var ExportForDataBrowser = (function() { 
	//Base64编码转换函数，用法Base64.encode(string)
	var Base64 = (function() { 
	// private property
		var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="; // private method for UTF-8 encoding
		function utf8Encode(string) {
			string = string.replace(/\r\n/g, "\n");
			var utftext = "";
			for (var n = 0; n < string.length; n++) {
				var c = string.charCodeAt(n);
				if (c < 128) {
					utftext += String.fromCharCode(c);
				} else if ((c > 127) && (c < 2048)) {
					utftext += String.fromCharCode((c >> 6) | 192);
					utftext += String.fromCharCode((c & 63) | 128);
				} else {
					utftext += String.fromCharCode((c >> 12) | 224);
					utftext += String.fromCharCode(((c >> 6) & 63) | 128);
					utftext += String.fromCharCode((c & 63) | 128);
				}
			}
			return utftext;
		} 
		// public method for encoding
		return { 
			// This was the original line, which tries to use Firefox's built in
			// Base64 encoder, but this kept throwing exceptions....
			// encode : (typeof btoa == 'function') ? function(input) { return
			// btoa(input); } : function (input) {
			encode: function(input) {
				var output = "";
				var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
				var i = 0;
				input = utf8Encode(input);
				while (i < input.length) {
					chr1 = input.charCodeAt(i++);
					chr2 = input.charCodeAt(i++);
					chr3 = input.charCodeAt(i++);
					enc1 = chr1 >> 2;
					enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
					enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
					enc4 = chr3 & 63;
					if (isNaN(chr2)) {
						enc3 = enc4 = 64;
					} else if (isNaN(chr3)) {
						enc4 = 64;
					}
					output = output + keyStr.charAt(enc1) + keyStr.charAt(enc2) + keyStr.charAt(enc3) + keyStr.charAt(enc4);
				}
				return output;
			}
		};
	})();
	var getType = (function() {
		return {
			getType: function(value) {
				var type = Ext.type(value);
				var result = "";
				switch (type) {
				case "number":
					result = "Number";
					break;
				case "int":
					result = "Number";
					break;
				case "float":
					result = "Number";
					break;
				case "bool":
				case "boolean":
					result = "String";
					break;
				case "date":
					result = "DateTime";
					break;
				default:
					result = "String";
					break;
				}
				return result;
			}
		};
	})();

	var CombineXmlAndExport=(function(){
		return{
			CombineXmlAndExport:function(inputGridStore,inputGridColumnModel){
				var storerows = inputGridStore.getCount();
				if (storerows==0)
				{
					Msg.info('warning','没有需要保存的数据！');
					return;
				}; 
				var storecols = inputGridColumnModel.getColumnCount();
				var temp_obj=[];	//存放需要导出的columns
				var arr_obj=[];		//存放原始record所有name
				var temp_obj=inputGridColumnModel.getColumnsBy(function(c){
					return !(c.hidden || c.dataIndex=="");
				});
				var temp_data = '<ss:Worksheet ss:Name="ExportTable Grid">';
				/*var headerXml = '<ss:Cell ss:StyleID="headercell" ss:MergeAcross="'
						+ (temp_obj.length - 1)
						+ '">'
						+ '<ss:Data ss:Type="String">'
						+ 'yunhaibaotesttitle'
						+ '</ss:Data>'
						+ '<ss:NamedCell ss:Name="Print_Titles" />'
						+ '</ss:Cell>';
				temp_data += '<ss:Table>' + '<ss:Column ss:AutoFitWidth="1"/>'
						+ '<ss:Row ss:AutoFitHeight="1">' + headerXml
						+ '</ss:Row>';*/ //注释部分可做标题行,放开时屏蔽下一行代码,yunhaibao20151126
				
				temp_data += '<ss:Table>' + '<ss:Column ss:AutoFitWidth="1"/>'
				temp_data += '<ss:Row>';  
				//标题
				for (var tempi=0;tempi<temp_obj.length;tempi++){
					temp_data += '<ss:Cell ss:StyleID="headercell"><ss:Data ss:Type="String">';
					temp_data += temp_obj[tempi].header;
				    temp_data += '</ss:Data></ss:Cell>';
				}
				temp_data += '</ss:Row>';
				//明细数据
				for (var temprow = 0; temprow < storerows; temprow++) {
					var storeArrRecord = inputGridStore.getAt(temprow);
					temp_data += '<ss:Row ss:Height="20">';
					for (var tempcol = 0; tempcol < temp_obj.length; tempcol++) { 
						var colDataIndex=temp_obj[tempcol].dataIndex;
						var cellValue=storeArrRecord.get(colDataIndex);
						temp_data += '<ss:Cell><ss:Data ss:Type="' + getType.getType(cellValue) + '">';
						temp_data += cellValue;
						temp_data += '</ss:Data></ss:Cell>';
					}
					
					temp_data += '</ss:Row>';
				}
				
				temp_data += '</ss:Table>';
				temp_data += '</ss:Worksheet>';
				var xmlcontent = '<xml version="1.0" encoding="utf-8">' 
				+ '<ss:Workbook xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:o="urn:schemas-microsoft-com:office:office">' 
				+ '<o:DocumentProperties><o:Title>' 
				+ '</o:Title></o:DocumentProperties>' 
				+ '<ss:Styles>' 
				+ '<ss:Style ss:ID="Default">' 
				+ '</ss:Style>' 
				+ '<ss:Style ss:ID="title">' 
				+ '<ss:NumberFormat ss:Format="@" />' 
				+ '</ss:Style>' 
				+ '<ss:Style ss:ID="headercell">' 
				+ '</ss:Style>' 
				+ '</ss:Styles>' 
				+ temp_data   //具体内容
				+ '</ss:Workbook>';

				var url = 'data:application/vnd.ms-excel;base64,' 
				+ Base64.encode(xmlcontent);
				//url没超长,浏览器链接地址长度有限制 
				window.location=url;
			}
		}
	})();
	var GridStoreToXml = (function() {
		return {
			GridStoreToXml: function(inputGrid, inputTitle) {
				if (inputGrid) {
					var inputGridStore = inputGrid.getStore();
					var inputGridParam = inputGridStore.lastOptions //此处克隆了原网格数据源的参数信息
					if (inputGridParam && inputGridParam.params) {
						inputGridParam.params[inputGridStore.paramNames.start]=0;
						inputGridParam.params[inputGridStore.paramNames.limit]=999999; //重置分页信息
					}
					var inputGridNewStore = new Ext.data.Store({	//重新定义一个数据源
						proxy: inputGridStore.proxy,
						reader: inputGridStore.reader,
						sortInfo:inputGridStore.sortInfo
					});
					inputGridNewStore.on('load', function (store) {
						CombineXmlAndExport.CombineXmlAndExport(store,inputGrid.getColumnModel())
					});
					inputGridNewStore.load(inputGridParam); //获取所有数据
					return true;
				}
			}
		};
	})();
	return { 
		//默认下载文件名无法修改,将浏览器设为每次下载询问文件保存位置
		DownloadByUrl: function(inputGrid, inputTitle) {
			GridStoreToXml.GridStoreToXml(inputGrid, inputTitle);
		}
	};
})();
/********不支持ActiveX浏览器的导出,结束***************/
function ReadFromExcel(fileName, Fn){
	try{
		var xlsApp = new ActiveXObject("Excel.Application");
	}catch(e){
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return false;
	}

	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: 使用第一个sheet
		ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn);
	}catch(e){
		Msg.info('error', '读取Excel失败:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return;		//没有return时,EXCEL.exe进程结束不了,why?
}
function ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	
	var StartRow = 1;		//第2行开始
	for(var i = StartRow; i < rowsLen; i++){
		//var rowData = xlsSheet.Range[ 'A1:G1' ].Copy;	//这句不能用, why?
		var rowData = '';
		for(var j = 0; j < colsLen; j++){
			var CellContent = xlsSheet.Cells((i + 1), (j + 1)).value;
			CellContent = typeof(CellContent)=='undefined'? '' : CellContent;
			if(!Ext.isEmpty(CellContent) && typeof(CellContent) == 'date'){
				CellContent = new Date(CellContent).format('Y-m-d');
			}
			if(j == 0){
				rowData = CellContent;
			}else{
				rowData = rowData + '\t' + CellContent;
			}
		}
		var impret=Fn(rowData, i+1);
		if (impret==false){
			break;
		}
	}
}
/**
 * 根据设置需要回车的列进行上下左右回车键的操作
 * creator	 yunhaibao
 * createdate20160421
 * @param {} grid 
 * @param {} proIndexName
 * @param {} walkFlag 
 */
function setKeyEventSort(grid,colArr,walkFlag) {
	//var addRowFlag=false;
	var cellWalkFlag=false;
	var rowdiff="",coldiff=""
	if(window.event.keyCode==38){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=38;} 
		rowdiff=-1,coldiff=0,cellWalkFlag=true;
	}
	if(window.event.keyCode==40){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=40;} 
		rowdiff=1,coldiff=0,cellWalkFlag=true;
	}
	if(window.event.keyCode==37){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=37;} 
		rowdiff=0,coldiff=-1,cellWalkFlag=true;
	}
	if(window.event.keyCode==39){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=39;} 
		rowdiff=0,coldiff=1,cellWalkFlag=true;
	}
	
	if(window.event.keyCode==13){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=13;} 
		cellWalkFlag=true;
	}
	if (walkFlag==false){return cellWalkFlag;}
	if ((rowdiff==="")||(coldiff==="")){return cellWalkFlag;}
	if(colArr.length<0){return cellWalkFlag;}
	var cel=grid.getSelectionModel().getSelectedCell()
	var indexName=grid.getColumnModel().getDataIndex(cel[1]);
	var gridCount=grid.getStore().getCount();
	var currentcol=GetColIndex(grid,indexName);
	for(var i=0; i<colArr.length;i++){
		var tempcol = colArr[i];
		if(tempcol.dataIndex==indexName){
			/*if(window.event.keyCode==13){
				if(i>=colArr.length-1){
					var currentcol=GetColIndex(grid,indexName);
					grid.stopEditing(cel[0], currentcol);
					addRowFlag=true;
				}
			}*/
			var nextIndex=colArr[i+coldiff].dataIndex
			var cell = grid.getSelectionModel().getSelectedCell();
			var nextIndexRow=cell[0]+rowdiff;
			var col=GetColIndex(grid,nextIndex);
			if ((nextIndexRow<gridCount)&&(nextIndexRow>=0)){
				grid.startEditing(nextIndexRow, col);
			}
		}
	}
	return cellWalkFlag;
}
/**
 * 格式化Grid中的售价金额
 * @param {} value
 * @return {}
 */
 function FormatGridSpAmount(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[5].toString().split(".")[1].length);
 	return inputValue;
 }
 /**
 * 格式化Grid中的进价金额
 * @param {} value
 * @return {}
 */
 function FormatGridRpAmount(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[3].toString().split(".")[1].length);
 	return inputValue;
 }
 /**
 * 格式化Grid中的批价金额
 * @param {} value
 * @return {}
 */
 function FormatGridPpAmount(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[4].toString().split(".")[1].length);
 	return inputValue;
 }
  /**
 * 格式化Grid中的进价
 * @param {} value
 * @return {}
 */
 function FormatGridRp(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[0].toString().split(".")[1].length);
 	return inputValue;
 }
/**
 * 格式化Grid中的售价
 * @param {} value
 * @return {}
 */
 function FormatGridSp(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[2].toString().split(".")[1].length);
 	return inputValue;
 }
/**
 * 格式化Grid中的数量补零
 * @param {} value
 * @return {}
 */
 function FormatGridQty(inputValue){
	if (isNaN(inputValue)==true){
		return inputValue;
	}	
 	return inputValue*1;
 }
 
 /**
  * @creator:	 yunhaibao
  * @createdate: 2016-12-22
  * @description:单据加锁解锁
  * @params:	 单据id,单据类型,L/UL(加锁/解锁)
  * @return:	 0:成功,1:失败
  */
 function DHCSTLockToggle(lockId,lockType,lockToggle){
	if ((lockId=="")||(lockType=="")||(lockToggle=="")){
		return 0;
	}
	var lockToggle=lockToggle.toUpperCase(); 
	var userId = session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var url=DictUrl+ 'commonparamconfig.csp?actiontype=WebSysLock'
		   +'&LocId='+locId+'&UserId='+userId+'&lockId='+lockId+'&lockType='+lockType+'&lockToggle='+lockToggle;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='false'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			Ext.Msg.show({
				title : '锁提示',
				msg : info,
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.WARNING
			});
		}
		return 1;
	}else{
		return 0;
	}
 }
 
 /**
  * @creator:	 yunhaibao
  * @createdate: 2017-03-15
  * @description:form查询条件style
  * @params:	 formid
  * @return:	 可用高度
  * style:DHCSTFormStyle.FrmPaddingV,
  * DHCSTFormStyle.FrmHeight(3)
  */
 var DHCSTFormStyle={
 	FrmHeight:function(rows){
	 	var frmheight=0;
	 	if (isIE()){
		 	if (Ext.isIE11){
			 	var frmheightobj={
					1:137, //ok
					2:165, //ok
					3:193, //ok
					4:221,
					5:249,
					6:277,
					7:308   //ok
				}
				frmheight=frmheightobj[rows];
			}else{
				//todo:目前针对ie8,其他版本视情况添加
				var frmheightobj={
					1:142,
					2:170,
					3:198,
					4:226,
					5:254,
					6:282,
					7:313
				}
				frmheight=frmheightobj[rows];
			}
		}else{
				var frmheightobj={
					1:142,
					2:170,
					3:198,
					4:226,
					5:254,
					6:282,
					7:313
				}
				frmheight=frmheightobj[rows];			
		}
	 	return frmheight;
	},
	FrmPaddingV:function(){
		var paddingstyle='padding-top:5px;padding-bottom:5px;';
		if (isIE()){
		 	if (Ext.isIE11){
			 	return paddingstyle;
		 	}else {
				return "padding-top:0px;padding-bottom:0px;";
			}
		}else{
			return paddingstyle;
		}
	},
	FrmPaddingH:function(){
	},
	ChkBoxLabel:function(){
		return "position:relative;top:1px;"
	}
 }

 /**
  * creator:	yunhaibao
  * createdate:	2017-05-02
  * description:将combox值赋给另一个combobox
  * @params{frombox:复制的comboboxid,tobox:赋值的comboboxid}
  * {frombox:"LocField",tobox:"RequestLoc"}	
  */
function CopyComboBoxStore(_params){
	var task = new Ext.util.DelayedTask(function(){
		var fromBox=_params.frombox;
		var toBox=_params.tobox;
		var fromBoxId=Ext.getCmp(fromBox).getValue();
		var fromBoxText=Ext.getCmp(fromBox).getRawValue();
	    addComboData(Ext.getCmp(toBox).getStore(), fromBoxId, fromBoxText);
	    Ext.getCmp(toBox).setValue(fromBoxId);
	});
	task.delay(100);	
}

// 动态加载js
function LoadJS(srcArr, callBack){
	var loadCnt = srcArr.length;
	var loadI = 0;
	Create();

	function Create() {
		if (loadI >= loadCnt) {
			callBack(loadI);
			return;
		}
		var src = srcArr[loadI];
		if (IsExist(src) == true) {
			loadI++;
			Create();
		} else {
			var head = document.getElementsByTagName('head')[0];
			var script = document.createElement('script');
			script.type = 'text/javascript';
			script.src = src;
			head.appendChild(script);
			script.onload = function () {
				loadI++;
				Create();
			}
		}
	}
// /名称: 全局变量及常用方法定义
// /描述: 全局变量及常用方法定义
// /编写者：zhangdongmei
// /编写日期: 2012.08.21
var DHCSTBlankBackGround="../csp/dhcst.blank.backgroud.csp"; //ext+润乾默认显示的报表背景
var PageSize = 30;
var RowDelim=String.fromCharCode(1);  //行数据间的分隔符
var FieldDelim="^";  //字段间的分隔符
var gParamCommon=[];
var gGrantStkGrp="";
var idTmr="";
// IE11判断 Ext.isIE11
Ext.apply(Ext, ((a = navigator.userAgent) && /Trident/.test(a) && /rv:11/.test(a)) ? {isIE11:true, ieVersion: 11} : {});
// 去掉fieldLabel的冒号
Ext.apply(Ext.form.Field.prototype,{labelSeparator:""});
// grid 行数列宽度
Ext.grid.RowNumberer.prototype.width = 30;

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
 * 执行数据库同步访问
 * @param {} url 访问路径
 * @return {}
 */
ExecuteDBSynAccess = function(url) {
	var conn = Ext.lib.Ajax.getConnectionObject().conn;
	conn.open("POST", url, false);
	conn.send();
	return conn.responseText.trim();
};

/**
 * 设置默认人员
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogUser = function(store, CmpName) {
	// 登录设置默认值
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
 * 设置登录科室
 * 
 * @param {}
 *            store
 * @param {}
 *            CmpName
 */
SetLogInDept = function(store, CmpName) {
	// 登录设置默认值
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
 * 为ComboBox赋值
 */
function addComboData(store, id, desc) {
	if(store.getById(id)==undefined){
		var defaultData = {
			RowId : id,
			Description : desc
		};
		var r = new store.recordType(defaultData);
		//store.removeAll();
		store.add(r);
	}
}

/**
 * 根据dateindex取grid列index
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
	removeMask: true //完成后移除
 });
 
 mk.show();
 return mk;
}

/**
 * 计算两个日期之间间隔的天数,参数格式必须为Y-m-d
 */
function DaysBetween(dateFrom,dateTo){
	//一天的毫秒数
	var oneDay=24*60*60*1000   
	
	//将两个日期转换为毫秒数
	var dateFrom_ms=Date.parse(dateFrom.replace(/-/g,"/"));   //dateFrom.getTime();  	
	var dateTo_ms=Date.parse(dateTo.replace(/-/g,"/"));   //dateTo.getTime();
	
	//// Calculate the difference in milliseconds
	var dateDiff_ms=Math.abs(dateTo_ms-dateFrom_ms);
	var dateDiff=Math.round(dateDiff_ms/oneDay); 
	

	return dateDiff;
}

/**
 * 将日期格式的字符串转换成Date类型
 */
function toDate(value){
	var dhcstdatefmt=App_StkDateFormat.toUpperCase();
	if(value==null || value==''){
		return value;
	}
	if(Ext.isDate(value)==true){
		return value;
	}
	var newValue=value;
	if(typeof value=='string'){
		if(value.indexOf('-')>=0){
			value=value.replace(/-/g,"/");
			var newValue=new Date(Date.parse(value));
		}else if((value.indexOf('/')>=0)&&(dhcstdatefmt.indexOf("/")>=0)){
			var tmpDate=value.split(" ")[0];
			var tmpTime=value.split(" ")[1];
			if (tmpTime==undefined){
				tmpTime="";
			}
			var datefmtarr=dhcstdatefmt.split("/");
			var tmpD=datefmtarr.indexOf("D");
			var tmpM=datefmtarr.indexOf("M");
			var tmpY=datefmtarr.indexOf("Y");
			var tmpDateArr=tmpDate.split("/");
			var tmpNewDate=tmpDateArr[tmpY]+"/"+tmpDateArr[tmpM]+"/"+tmpDateArr[tmpD]
		    tmpNewDate=tmpNewDate+" "+tmpTime;
			var newValue=new Date(Date.parse(tmpNewDate));
		}
	}
	
	return newValue;
}

 //屏蔽编辑页面上BackSpace键
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


 //返回取备注类型字段时，备注行之间的设定分隔符$c(3) 
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return realkey;
}

//对后台返回的备注字段加以处理-即使用回车换行符 $c(13,10) 替换$c(3)
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
		//如果不是数字的话原值返回
		if (isNaN(value)==true){
			return value;
		}
		//if(/^\d*\.{0,1}\d*$/.test(value)==false){
		//	return value;
		//}
		
		var newValue=Number(value).toFixed(decimalLen);
		return newValue;
}

//合并某列中相同的行数据
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


/*  LiangQiang 2014-09-02*/
function gridSaveAsExcel(grid)
{
  	if (grid.getStore().getCount()==0)
	{
		Msg.info('warning','没有需要保存的数据！');
		return;
	};  
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return "";
	}
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	
	var cm=grid.getColumnModel();
	var colCount=cm.getColumnCount();
	var temp_obj=[];

	for (i=1;i<colCount;i++)
	{
		if (cm.isHidden(i) ==true)
		{}
		else
		{
			temp_obj.push(i);  //只存没有隐藏的列
		}
	}

	//Excel第一行存放标题
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
			xlSheet.Cells(k+1,j).Value=view.getCell(k-1,temp_obj[j-1]).innerText;
		}
	} 	   
	try
	{
		var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
 		var ss = xlBook.SaveAs(fileName);  
	 	if (ss==false)
		{
			Msg.info('error','另存失败！') ;
		}		
	}
	catch(e){
		 Msg.info('error','另存失败！') ;
	}


	xlSheet=null;
    xlBook.Close (savechanges=false);
    xlBook=null;
    xlApp.Quit();
    xlApp=null;
	window.setInterval("Cleanup();",1);
 	   
}

function SetFieldOriginal(field){
	if(field.items!=null){
		field.items.each(function(subField){
			SetFieldOriginal(subField);
		});
	}else{
		field.originalValue=String(field.getValue());
	}
}

///设置表单初始值, 在查询返回表单信息之后调用
///panel:表单所在的panel名称
function SetFormOriginal(panel){
	var panelId=panel.getId();
	Ext.getCmp(panelId).getForm().items.each(function(f){
		SetFieldOriginal(f);
	});
}

///判断表单是否发生改变
///return: true, false
function IsFormChanged(panel){
	var panelId=panel.getId();
	var isMainChanged=Ext.getCmp(panelId).getForm().isDirty();
	return isMainChanged;
}

/*使Enter键按Tab键执行*/
function setEnterTab(panel)
{
	panel.getForm().items.each(function(f){
		f.on('specialkey',function(id,e){
			var keyCode=e.getKey();
			if(keyCode==e.ENTER)
			{
			window.event.keyCode=9; }
		})
	})

}

 

/*
 * creator:wyx,2014-03-13
 * description:取参数配置公共模块界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return:
     进价小数位数(入库单位)^批价小数位数(入库单位)^售价小数位数(入库单位)^进价金额小数位数
      ^批价金额小数位数^售价金额小数位数^集团化标志^进价规则^库存数量小数位数^类组设置
*/ 

function GetParamCommon(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcst.commonparamconfig.csp?actiontype=GetParamCommon&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gParamCommon=info.split('^');
		}
	}

	return;
}
/*
 * creator:wyx,2014-04-28
 * description:取登录人员所被授权的所有类组以“^”连接
 * params: 
 * return:被授权的所有类组以“^”连接
*/
function GetGrantStkGrp(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url=DictUrl+ 'extux.csp?actiontype=GetGrantStkGrp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gGrantStkGrp=info;
		}
	}

	return;
}


function Cleanup() //清除打印后遗留死进程 lq 2007-10-12
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}

/**保存store中的数据到excel文件 
 * 要求:浏览器允许执行ActiveX控件
 * yunhaibao,20151230,每次写入一行数据,提高导出速度
 */
function StoreSaveAsExcel(store,cm,fileName){
    if (store.getCount()==0){
      Msg.info('warning','没有需要保存的数据！');
      return;
  };
  var titleObj={};
  var temp_obj=[];	//存放需要导出的columns

  var temp_obj=cm.getColumnsBy(function(c){
      return !(c.hidden || c.dataIndex=="");
  });
  // Excel第一行存放标题	
  for (var n=0;n<temp_obj.length;n++){
      var temp_obj_n=temp_obj[n];
      var tmpHeader=temp_obj_n.header.replace(/<\/?[^>]*>/g,'');
      var tmpIndex=temp_obj_n.dataIndex 
      titleObj[tmpIndex]=tmpHeader
  }
  // 格式化数据
  var rowsData=[];
  var recordCount=store.getCount();
  for (var k=0;k<recordCount;k++){
      var colobj=[];
      var arrRecord=store.getAt(k);
      var rowData={};
      for (var j=0;j<temp_obj.length;j++){
          var colDataIndex=temp_obj[j].dataIndex;
          var cellValue=arrRecord.get(colDataIndex);
          // 单位,厂家等信息需要如下操作
          if (cellValue=="NULL"){cellValue=""}
          var colRenderer=cm.getRenderer(cm.getIndexById(temp_obj[j].id));
          
          if(Ext.isFunction(colRenderer)&&temp_obj[j].xtype!="checkcolumn"){
              try{
                  if (colRenderer(cellValue,j,arrRecord,k,j,store)){
                        var newcellValue=colRenderer(cellValue,j,arrRecord,k,j,store);
                        if ((newcellValue.indexOf("span")<0)&&(newcellValue.indexOf("check")<0)&&(newcellValue.indexOf("<a")<0)){
                            cellValue=newcellValue
                        }	
                  }
              }
              catch(e){
              }
          }
          if ((parseInt(cellValue)==cellValue)&&(cellValue!=0)){
              if (cellValue.toString().charAt(0)==0){
                  cellValue="'"+cellValue;
              }
          }
          rowData[colDataIndex]=cellValue;	
          
      }
      rowsData.push(rowData);
  }
  
  LoadJS(["../scripts/pha/com/v1/js/export.js"],function(){
      PHA_EXPORT.XLSX(titleObj,rowsData,fileName);
  });
  
  return;
  // 下方为原始导出
  try{
      var fso = new ActiveXObject("Scripting.FileSystemObject");
      var sTextfile = fso.CreateTextFile(fileName,true,true)
      var colCount=cm.getColumnCount();
      var temp_obj=[];	//存放需要导出的columns
      var arr_obj=[];		//存放原始record所有name

      var temp_obj=cm.getColumnsBy(function(c){
          return !(c.hidden || c.dataIndex=="");
      });
      //Excel第一行存放标题
      var tmpwriterecord="",tmpheader="",tmpheaderarr=[];
      var DelimCol=String.fromCharCode(9);	
      for (var n=0;n<temp_obj.length;n++){
          tmpheader=temp_obj[n].header.replace(/<\/?[^>]*>/g,'');
          if (tmpwriterecord=="") {tmpwriterecord=tmpheader;}
          else {tmpwriterecord=tmpwriterecord+DelimCol+tmpheader;}
          tmpheaderarr[n]=tmpheader;
      }
      sTextfile.WriteLine(tmpwriterecord)
      var recordCount=store.getCount();
      for (var k=0;k<recordCount;k++){
          var colobj=[];
          var arrRecord=store.getAt(k);
          tmpwriterecord=""
          for (var j=0;j<temp_obj.length;j++){
              var colDataIndex=temp_obj[j].dataIndex;
              var cellValue=arrRecord.get(colDataIndex);
              // 单位,厂家等信息需要如下操作
              if (cellValue=="NULL"){cellValue=""}
              var colRenderer=cm.getRenderer(cm.getIndexById(temp_obj[j].id));
              if(Ext.isFunction(colRenderer)&&temp_obj[j].xtype!="checkcolumn"){
                  try{
                      if (colRenderer(cellValue,j,arrRecord,k,j,store)){
                            var newcellValue=colRenderer(cellValue,j,arrRecord,k,j,store);
                            if ((newcellValue.indexOf("span")<0)&&(newcellValue.indexOf("check")<0)&&(newcellValue.indexOf("<a")<0)){
                                cellValue=newcellValue
                            }	
                      }
                  }
                  catch(e){
                  }
              }
              if ((parseInt(cellValue)==cellValue)&&(cellValue!=0)){
                  if (cellValue.toString().charAt(0)==0){
                      cellValue="'"+cellValue;
                  }
              }	
              if (tmpwriterecord==""){tmpwriterecord=cellValue;}
              else{tmpwriterecord=tmpwriterecord+DelimCol+cellValue;}	
          }
          
          sTextfile.WriteLine(tmpwriterecord)
      }
      store.destroy();
      sTextfile.Close();
         sTextfile=null;
      fso=null;	
      Msg.info('success',"另存成功!") ;
      window.setInterval("Cleanup();",1);	
  }
  catch(e){
      Msg.info('error',e.message) ;
  }  
}



/**分页导出所有Excel导出方法 
 * yunhaibao20151231,添加当无MSComDlg.CommonDialog权限时,前台提示是否写入注册表
 */
function ExportAllToExcel(gridPanel) {
	//if (isIE()){
	if (1==1){
		if (gridPanel) {
			var tmpStore = gridPanel.getStore();
			if (tmpStore.getCount()==0)
			{
				Msg.info('warning','没有需要保存的数据！');
				return;
			};
			//以下处理分页grid数据导出的问题，从服务器中获取所有数据，需要考虑性能
			var tmpParam = tmpStore.lastOptions //此处克隆了原网格数据源的参数信息
			if (tmpParam && tmpParam.params) {
				tmpParam.params[tmpStore.paramNames.start]=0;
				tmpParam.params[tmpStore.paramNames.limit]=999999; //重置分页信息
			}
			var tmpAllStore = new Ext.data.Store({	//重新定义一个数据源
				proxy: tmpStore.proxy,
				reader: tmpStore.reader
			});
			if (tmpStore.sortInfo){
				tmpParam.params["sort"]=tmpStore.sortInfo.field;
				tmpParam.params["dir"]=tmpStore.sortInfo.direction;
			}
			/*
			try{
    				
				var mscd = new ActiveXObject("MSComDlg.CommonDialog");
				mscd.Filter = "Microsoft Office Excel(*.xlsx)|*.xlsx";
				mscd.FilterIndex = 1;
				// 必须设置MaxFileSize. 否则出错
				mscd.MaxFileSize = 32767;
				// 显示对话框
				mscd.ShowSave();
				var fileName=mscd.FileName;
				mscd=null;
			}
			catch(e)
			{
					if (confirm("当前系统不支持创建路径,是否载入文件配置?\n载入成功后,重启浏览器生效!\n如重启后不生效请添加信任站点并注册scrrun.dll、COMDLG32.OCX！"))
					{
						var fso = new ActiveXObject("Scripting.FileSystemObject");
						var sTextfile = fso.CreateTextFile("C:\\MSCommonDialog.reg",true)
						sTextfile.WriteLine("Windows Registry Editor Version 5.00")
						sTextfile.WriteLine("[HKEY_CLASSES_ROOT\\Licenses\\4D553650-6ABE-11cf-8ADB-00AA00C00905]")
						sTextfile.WriteLine("@=\"gfjmrfkfifkmkfffrlmmgmhmnlulkmfmqkqj\"")
						sTextfile.Close();
	   					sTextfile=null;
	    				fso=null;
	    				var shell = new ActiveXObject("WScript.Shell"); 
	    				shell.Run("C:\\MSCommonDialog.reg");
	    				return;
	    					
					}
					else{
						return;					
					}
			}*/
			var fileName='数据导出_' + new Date().getTime() + '.xlsx'; 
			if (fileName=='') return;
			var loadMask=ShowLoadMask(document.body,"处理中...");
			tmpAllStore.on('load', function (store) {
				loadMask.hide();
				StoreSaveAsExcel(store,gridPanel.getColumnModel(),fileName)
				
			});
			tmpAllStore.load(tmpParam); //获取所有数据
		}
	}
	else{
		try{
			ExportForDataBrowser.DownloadByUrl(gridPanel, "");
		}
		catch(e){
			alert(e.message)
		}
	}
};

/**
 * 设置回车跳转的顺序
 * @param {} grid 
 * @param {} proIndexName
 */
function setEnterSort(grid,colArr) {
	var addRowFlag=true;
	//if(window.event.keyCode!=13){return false;}  //yunhaibao20161129注释
	if(colArr.length<=0) return;
	var cel=grid.getSelectionModel().getSelectedCell()
	var indexName=grid.getColumnModel().getDataIndex(cel[1]);
	for(var i=0; i<colArr.length;i++){
		var tempcol = colArr[i];
		if(tempcol.dataIndex==indexName){
			if(i<colArr.length-1){
				var nextIndex=colArr[i+1].dataIndex
				var cell = grid.getSelectionModel().getSelectedCell();
				var col=GetColIndex(grid,nextIndex);
				grid.startEditing(cell[0], col);
				addRowFlag=false;
			}
			else{
				var currentcol=GetColIndex(grid,indexName);
				grid.stopEditing(cel[0], currentcol);
			}
		}
	}
	return addRowFlag;
}
/**
 * 初始化跳转顺序,不走配置形式
 * @param {} grid
 * @return {}
 * nosortarr为预留参数,传入的数组不参与跳转
 */
function sortColoumByEnter(grid,nosortarr){
	if ((nosortarr==undefined)||(nosortarr==null)){
		nosortarr=""
	}
	var columnModel=grid.getColumnModel();
	var colArr=[];
	for(var a=0; a<columnModel.getColumnCount();a++){
		var col=grid.getColumnModel().config[a];
		if(col.hidden) {
			continue;
		}
		if (nosortarr!=""){
			if(nosortarr.indexOf(col.dataIndex)>=0){
				continue;
			}
		}
		if (col.editor==null)  //不可编辑不进行跳转
		{
		   continue;
		}
		colArr.push(col)
	}
	//按enterSort进行排序
	colArr.sort(function(obj1,obj2){
            return obj1.enterSort-obj2.enterSort});
	return colArr;
}
/**
 * 初始化跳转顺序
 * @param {} grid
 * @return {}
 */
function sortColoumByEnterSort(grid){
	var columnModel=grid.getColumnModel();
	var colArr=[];
	for(var a=0; a<columnModel.getColumnCount();a++){
		var col=grid.getColumnModel().config[a];
		if(col.hidden) {
			continue;
		}
		if(col.enterSort>0){
			colArr.push(col)
		}
	}
	//按enterSort进行排序,yunhaibao20170718,目前用不上,没看懂
	//colArr.sort(function(obj1,obj2){
    //        return obj1.enterSort-obj2.enterSort});
	return colArr;
} 

/**
 * 实例化record
 * 简化record实例化代码,返回实例化的record
 * @param {} RecordObject	:Record结构,可以用store.fields
 * @param {} NewRecord		:特殊赋值,形如{fieldA:valueA,fieldB:valueB,...}
 * 							该值传入"",null,{},或者不传,都可以
 * 例如库存调整中:var NewRecord=CreateRecordInstance(INAdjMGridDs.fields);
 */
function CreateRecordInstance(RecordObject,SpecialValue){
	SpecialValue = SpecialValue||{};
	var record = new Ext.data.Record.create(RecordObject);
	var NewRecord = new record(SpecialValue);
	for(var n=0;n<RecordObject.items.length;n++){
		var tmpField=RecordObject.items[n];
		if(NewRecord.data[tmpField.name]==undefined){
			//这里是set空,还是set缺省值呢?
			NewRecord.set(tmpField.name,tmpField.defaultValue);
		}
	}
	return NewRecord;
}

 //判断是否是IE,仅IE支持ActiveXObject
function isIE() {   
    if (!!window.ActiveXObject || "ActiveXObject" in window) { 
    	return true;
    }  
    else{
	    return false;
	} 
}
/*
 * creator:yunhaibao
 * createdate: 2015-11-27
 * description:针对data协议浏览器的导出
 * others:超长问题尚未解决,几百条数据还行
 * params: 
*/
var ExportForDataBrowser = (function() { 
	//Base64编码转换函数，用法Base64.encode(string)
	var Base64 = (function() { 
	// private property
		var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="; // private method for UTF-8 encoding
		function utf8Encode(string) {
			string = string.replace(/\r\n/g, "\n");
			var utftext = "";
			for (var n = 0; n < string.length; n++) {
				var c = string.charCodeAt(n);
				if (c < 128) {
					utftext += String.fromCharCode(c);
				} else if ((c > 127) && (c < 2048)) {
					utftext += String.fromCharCode((c >> 6) | 192);
					utftext += String.fromCharCode((c & 63) | 128);
				} else {
					utftext += String.fromCharCode((c >> 12) | 224);
					utftext += String.fromCharCode(((c >> 6) & 63) | 128);
					utftext += String.fromCharCode((c & 63) | 128);
				}
			}
			return utftext;
		} 
		// public method for encoding
		return { 
			// This was the original line, which tries to use Firefox's built in
			// Base64 encoder, but this kept throwing exceptions....
			// encode : (typeof btoa == 'function') ? function(input) { return
			// btoa(input); } : function (input) {
			encode: function(input) {
				var output = "";
				var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
				var i = 0;
				input = utf8Encode(input);
				while (i < input.length) {
					chr1 = input.charCodeAt(i++);
					chr2 = input.charCodeAt(i++);
					chr3 = input.charCodeAt(i++);
					enc1 = chr1 >> 2;
					enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
					enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
					enc4 = chr3 & 63;
					if (isNaN(chr2)) {
						enc3 = enc4 = 64;
					} else if (isNaN(chr3)) {
						enc4 = 64;
					}
					output = output + keyStr.charAt(enc1) + keyStr.charAt(enc2) + keyStr.charAt(enc3) + keyStr.charAt(enc4);
				}
				return output;
			}
		};
	})();
	var getType = (function() {
		return {
			getType: function(value) {
				var type = Ext.type(value);
				var result = "";
				switch (type) {
				case "number":
					result = "Number";
					break;
				case "int":
					result = "Number";
					break;
				case "float":
					result = "Number";
					break;
				case "bool":
				case "boolean":
					result = "String";
					break;
				case "date":
					result = "DateTime";
					break;
				default:
					result = "String";
					break;
				}
				return result;
			}
		};
	})();

	var CombineXmlAndExport=(function(){
		return{
			CombineXmlAndExport:function(inputGridStore,inputGridColumnModel){
				var storerows = inputGridStore.getCount();
				if (storerows==0)
				{
					Msg.info('warning','没有需要保存的数据！');
					return;
				}; 
				var storecols = inputGridColumnModel.getColumnCount();
				var temp_obj=[];	//存放需要导出的columns
				var arr_obj=[];		//存放原始record所有name
				var temp_obj=inputGridColumnModel.getColumnsBy(function(c){
					return !(c.hidden || c.dataIndex=="");
				});
				var temp_data = '<ss:Worksheet ss:Name="ExportTable Grid">';
				/*var headerXml = '<ss:Cell ss:StyleID="headercell" ss:MergeAcross="'
						+ (temp_obj.length - 1)
						+ '">'
						+ '<ss:Data ss:Type="String">'
						+ 'yunhaibaotesttitle'
						+ '</ss:Data>'
						+ '<ss:NamedCell ss:Name="Print_Titles" />'
						+ '</ss:Cell>';
				temp_data += '<ss:Table>' + '<ss:Column ss:AutoFitWidth="1"/>'
						+ '<ss:Row ss:AutoFitHeight="1">' + headerXml
						+ '</ss:Row>';*/ //注释部分可做标题行,放开时屏蔽下一行代码,yunhaibao20151126
				
				temp_data += '<ss:Table>' + '<ss:Column ss:AutoFitWidth="1"/>'
				temp_data += '<ss:Row>';  
				//标题
				for (var tempi=0;tempi<temp_obj.length;tempi++){
					temp_data += '<ss:Cell ss:StyleID="headercell"><ss:Data ss:Type="String">';
					temp_data += temp_obj[tempi].header;
				    temp_data += '</ss:Data></ss:Cell>';
				}
				temp_data += '</ss:Row>';
				//明细数据
				for (var temprow = 0; temprow < storerows; temprow++) {
					var storeArrRecord = inputGridStore.getAt(temprow);
					temp_data += '<ss:Row ss:Height="20">';
					for (var tempcol = 0; tempcol < temp_obj.length; tempcol++) { 
						var colDataIndex=temp_obj[tempcol].dataIndex;
						var cellValue=storeArrRecord.get(colDataIndex);
						temp_data += '<ss:Cell><ss:Data ss:Type="' + getType.getType(cellValue) + '">';
						temp_data += cellValue;
						temp_data += '</ss:Data></ss:Cell>';
					}
					
					temp_data += '</ss:Row>';
				}
				
				temp_data += '</ss:Table>';
				temp_data += '</ss:Worksheet>';
				var xmlcontent = '<xml version="1.0" encoding="utf-8">' 
				+ '<ss:Workbook xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:o="urn:schemas-microsoft-com:office:office">' 
				+ '<o:DocumentProperties><o:Title>' 
				+ '</o:Title></o:DocumentProperties>' 
				+ '<ss:Styles>' 
				+ '<ss:Style ss:ID="Default">' 
				+ '</ss:Style>' 
				+ '<ss:Style ss:ID="title">' 
				+ '<ss:NumberFormat ss:Format="@" />' 
				+ '</ss:Style>' 
				+ '<ss:Style ss:ID="headercell">' 
				+ '</ss:Style>' 
				+ '</ss:Styles>' 
				+ temp_data   //具体内容
				+ '</ss:Workbook>';

				var url = 'data:application/vnd.ms-excel;base64,' 
				+ Base64.encode(xmlcontent);
				//url没超长,浏览器链接地址长度有限制 
				window.location=url;
			}
		}
	})();
	var GridStoreToXml = (function() {
		return {
			GridStoreToXml: function(inputGrid, inputTitle) {
				if (inputGrid) {
					var inputGridStore = inputGrid.getStore();
					var inputGridParam = inputGridStore.lastOptions //此处克隆了原网格数据源的参数信息
					if (inputGridParam && inputGridParam.params) {
						inputGridParam.params[inputGridStore.paramNames.start]=0;
						inputGridParam.params[inputGridStore.paramNames.limit]=999999; //重置分页信息
					}
					var inputGridNewStore = new Ext.data.Store({	//重新定义一个数据源
						proxy: inputGridStore.proxy,
						reader: inputGridStore.reader,
						sortInfo:inputGridStore.sortInfo
					});
					inputGridNewStore.on('load', function (store) {
						CombineXmlAndExport.CombineXmlAndExport(store,inputGrid.getColumnModel())
					});
					inputGridNewStore.load(inputGridParam); //获取所有数据
					return true;
				}
			}
		};
	})();
	return { 
		//默认下载文件名无法修改,将浏览器设为每次下载询问文件保存位置
		DownloadByUrl: function(inputGrid, inputTitle) {
			GridStoreToXml.GridStoreToXml(inputGrid, inputTitle);
		}
	};
})();
/********不支持ActiveX浏览器的导出,结束***************/
function ReadFromExcel(fileName, Fn){
	try{
		var xlsApp = new ActiveXObject("Excel.Application");
	}catch(e){
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return false;
	}

	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: 使用第一个sheet
		ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn);
	}catch(e){
		Msg.info('error', '读取Excel失败:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return;		//没有return时,EXCEL.exe进程结束不了,why?
}
function ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	
	var StartRow = 1;		//第2行开始
	for(var i = StartRow; i < rowsLen; i++){
		//var rowData = xlsSheet.Range[ 'A1:G1' ].Copy;	//这句不能用, why?
		var rowData = '';
		for(var j = 0; j < colsLen; j++){
			var CellContent = xlsSheet.Cells((i + 1), (j + 1)).value;
			CellContent = typeof(CellContent)=='undefined'? '' : CellContent;
			if(!Ext.isEmpty(CellContent) && typeof(CellContent) == 'date'){
				CellContent = new Date(CellContent).format('Y-m-d');
			}
			if(j == 0){
				rowData = CellContent;
			}else{
				rowData = rowData + '\t' + CellContent;
			}
		}
		var impret=Fn(rowData, i+1);
		if (impret==false){
			break;
		}
	}
}
/**
 * 根据设置需要回车的列进行上下左右回车键的操作
 * creator	 yunhaibao
 * createdate20160421
 * @param {} grid 
 * @param {} proIndexName
 * @param {} walkFlag 
 */
function setKeyEventSort(grid,colArr,walkFlag) {
	//var addRowFlag=false;
	var cellWalkFlag=false;
	var rowdiff="",coldiff=""
	if(window.event.keyCode==38){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=38;} 
		rowdiff=-1,coldiff=0,cellWalkFlag=true;
	}
	if(window.event.keyCode==40){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=40;} 
		rowdiff=1,coldiff=0,cellWalkFlag=true;
	}
	if(window.event.keyCode==37){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=37;} 
		rowdiff=0,coldiff=-1,cellWalkFlag=true;
	}
	if(window.event.keyCode==39){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=39;} 
		rowdiff=0,coldiff=1,cellWalkFlag=true;
	}
	
	if(window.event.keyCode==13){
		if(event.preventDefault){event.preventDefault();}
		else {event.keyCode=13;} 
		cellWalkFlag=true;
	}
	if (walkFlag==false){return cellWalkFlag;}
	if ((rowdiff==="")||(coldiff==="")){return cellWalkFlag;}
	if(colArr.length<0){return cellWalkFlag;}
	var cel=grid.getSelectionModel().getSelectedCell()
	var indexName=grid.getColumnModel().getDataIndex(cel[1]);
	var gridCount=grid.getStore().getCount();
	var currentcol=GetColIndex(grid,indexName);
	for(var i=0; i<colArr.length;i++){
		var tempcol = colArr[i];
		if(tempcol.dataIndex==indexName){
			/*if(window.event.keyCode==13){
				if(i>=colArr.length-1){
					var currentcol=GetColIndex(grid,indexName);
					grid.stopEditing(cel[0], currentcol);
					addRowFlag=true;
				}
			}*/
			var nextIndex=colArr[i+coldiff].dataIndex
			var cell = grid.getSelectionModel().getSelectedCell();
			var nextIndexRow=cell[0]+rowdiff;
			var col=GetColIndex(grid,nextIndex);
			if ((nextIndexRow<gridCount)&&(nextIndexRow>=0)){
				grid.startEditing(nextIndexRow, col);
			}
		}
	}
	return cellWalkFlag;
}
/**
 * 格式化Grid中的售价金额
 * @param {} value
 * @return {}
 */
 function FormatGridSpAmount(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[5].toString().split(".")[1].length);
 	return inputValue;
 }
 /**
 * 格式化Grid中的进价金额
 * @param {} value
 * @return {}
 */
 function FormatGridRpAmount(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[3].toString().split(".")[1].length);
 	return inputValue;
 }
 /**
 * 格式化Grid中的批价金额
 * @param {} value
 * @return {}
 */
 function FormatGridPpAmount(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[4].toString().split(".")[1].length);
 	return inputValue;
 }
  /**
 * 格式化Grid中的进价
 * @param {} value
 * @return {}
 */
 function FormatGridRp(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[0].toString().split(".")[1].length);
 	return inputValue;
 }
/**
 * 格式化Grid中的售价
 * @param {} value
 * @return {}
 */
 function FormatGridSp(inputValue){
	var DecimalParamCommon=gParamCommon;
	inputValue=DecimalFormat(inputValue,DecimalParamCommon[2].toString().split(".")[1].length);
 	return inputValue;
 }
/**
 * 格式化Grid中的数量补零
 * @param {} value
 * @return {}
 */
 function FormatGridQty(inputValue){
	if (isNaN(inputValue)==true){
		return inputValue;
	}	
 	return inputValue*1;
 }
 
 /**
  * @creator:	 yunhaibao
  * @createdate: 2016-12-22
  * @description:单据加锁解锁
  * @params:	 单据id,单据类型,L/UL(加锁/解锁)
  * @return:	 0:成功,1:失败
  */
 function DHCSTLockToggle(lockId,lockType,lockToggle){
	if ((lockId=="")||(lockType=="")||(lockToggle=="")){
		return 0;
	}
	var lockToggle=lockToggle.toUpperCase(); 
	var userId = session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var url=DictUrl+ 'commonparamconfig.csp?actiontype=WebSysLock'
		   +'&LocId='+locId+'&UserId='+userId+'&lockId='+lockId+'&lockType='+lockType+'&lockToggle='+lockToggle;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='false'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			Ext.Msg.show({
				title : '锁提示',
				msg : info,
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.WARNING
			});
		}
		return 1;
	}else{
		return 0;
	}
 }
 
 /**
  * @creator:	 yunhaibao
  * @createdate: 2017-03-15
  * @description:form查询条件style
  * @params:	 formid
  * @return:	 可用高度
  * style:DHCSTFormStyle.FrmPaddingV,
  * DHCSTFormStyle.FrmHeight(3)
  */
 var DHCSTFormStyle={
 	FrmHeight:function(rows){
	 	var frmheight=0;
	 	if (isIE()){
		 	if (Ext.isIE11){
			 	var frmheightobj={
					1:137, //ok
					2:165, //ok
					3:193, //ok
					4:221,
					5:249,
					6:277,
					7:308   //ok
				}
				frmheight=frmheightobj[rows];
			}else{
				//todo:目前针对ie8,其他版本视情况添加
				var frmheightobj={
					1:142,
					2:170,
					3:198,
					4:226,
					5:254,
					6:282,
					7:313
				}
				frmheight=frmheightobj[rows];
			}
		}else{
				var frmheightobj={
					1:142,
					2:170,
					3:198,
					4:226,
					5:254,
					6:282,
					7:313
				}
				frmheight=frmheightobj[rows];			
		}
	 	return frmheight;
	},
	FrmPaddingV:function(){
		var paddingstyle='padding-top:5px;padding-bottom:5px;';
		if (isIE()){
		 	if (Ext.isIE11){
			 	return paddingstyle;
		 	}else {
				return "padding-top:0px;padding-bottom:0px;";
			}
		}else{
			return paddingstyle;
		}
	},
	FrmPaddingH:function(){
	},
	ChkBoxLabel:function(){
		return "position:relative;top:1px;"
	}
 }

 /**
  * creator:	yunhaibao
  * createdate:	2017-05-02
  * description:将combox值赋给另一个combobox
  * @params{frombox:复制的comboboxid,tobox:赋值的comboboxid}
  * {frombox:"LocField",tobox:"RequestLoc"}	
  */
function CopyComboBoxStore(_params){
	var task = new Ext.util.DelayedTask(function(){
		var fromBox=_params.frombox;
		var toBox=_params.tobox;
		var fromBoxId=Ext.getCmp(fromBox).getValue();
		var fromBoxText=Ext.getCmp(fromBox).getRawValue();
	    addComboData(Ext.getCmp(toBox).getStore(), fromBoxId, fromBoxText);
	    Ext.getCmp(toBox).setValue(fromBoxId);
	});
	task.delay(100);	
}

// 动态加载js
function LoadJS(srcArr, callBack){
	var loadCnt = srcArr.length;
	var loadI = 0;
	Create();

	function Create() {
		if (loadI >= loadCnt) {
			callBack(loadI);
			return;
		}
		var src = srcArr[loadI];
		if (IsExist(src) == true) {
			loadI++;
			Create();
		} else {
			var head = document.getElementsByTagName('head')[0];
			var script = document.createElement('script');
			script.type = 'text/javascript';
			script.src = src;
			head.appendChild(script);
			script.onload = function () {
				loadI++;
				Create();
			}
		}
	}

	function IsExist(src) {
		var scriptArr = document.getElementsByTagName('script');
		for (var i = 0; i < scriptArr.length; i++) {
			if ((scriptArr[i].src).indexOf(src.replace("../", "")) >= 0) {
				return true;
			}
		}
		return false;
	}
}



	function IsExist(src) {
		var scriptArr = document.getElementsByTagName('script');
		for (var i = 0; i < scriptArr.length; i++) {
			if ((scriptArr[i].src).indexOf(src.replace("../", "")) >= 0) {
				return true;
			}
		}
		return false;
	}
}


// 给小于1的数值补0，如果不是数值的值不变
function SetNumber(val,meta){
			//if (val=="今日已有生效记录")
			//meta.css='classRed';
			var newnum=parseFloat(val)
			if(!newnum) newnum=val
			else newnum=Number(val) 
			
			return newnum
		
		}

/**
* 加载医院的公共方法
* options ={
*	stores : [store1,store2,store3], //选择医院时,需要根据医院重新加载数据的store
*	grids : [StkCatGrid], //选择医院时,需要清空数据的grid
*	selHandler : function(){}, //选择医院事件
*   movepanel:['CTLocPanel','StkLocCatGroupPanel']  //因为新增的医院下拉框遮罩了页面原本显示内容，需要将页面布局下拉，此处放入需要下拉的元素的id(可以是panel，gird，不能放Viewport)
*	}
*/
function initHosp(options)
{
	//csp作为嵌入页面时,不需要重复加载医院组件,通过urlHospId传递医院ID
	if((typeof(urlHospId) == "undefined")||(urlHospId=="")){
		//开启了院区授权功能才显示出来
		var hospAutFlag=tkMakeServerCall("PHA.FACE.IN.Com","GetHospAut")
		if(hospAutFlag=="Y"){
			var movepanellen=0;
			if(options.movepanel)  movepanellen=options.movepanel.length
			if(movepanellen>0)  
			{
				for (i=0;i<movepanellen;i++)
				Ext.fly(options.movepanel[i]).setStyle('padding-top','30px');		
			}
			//加载医院组件到界面
			var opt=$.extend({
				fieldLabel : '<font color=red>*医院</font>',
				id : 'Hospital',
				name : 'Hospital',
				anchor : '90%'		
			},options); 
			var Hospital = new Ext.ux.HospComboBox(opt);
			var hospPanel = new Ext.FormPanel({ 
				bodyStyle:'background:#DCE8F6;padding-top:3px;',
				layout: 'form',
				labelAlign:'right',
				labelWidth:40,
				border:true,
				region: 'north'  ,
		        items:[Hospital]  ,
		        height : 30                           
			});
			hospPanel.render(Ext.getBody());		
		}
	}
	else{
		HospId=urlHospId;
	}	
}
function InitHospCombo(tableName,callBack){
	var hospComp=GenHospComp(tableName);
	hospComp.on('select',callBack);	
	var hospPanel=GenHospPanel(hospComp);
	return hospPanel;
}
/// 每次后台交互都传个医院
Ext.Ajax.on('beforerequest', function(conn,options){
	options.params=$.extend(options.params,{HospId:HospId});
},this);

/**
 * @creator: Huxt 2020-03-06
 * @desc: 替换中括号
 */
function ReplaceMidBrackets(str){
	var str = PHA_ReplaceAll(str, "\\[", "\(");
	return PHA_ReplaceAll(str, "\\]", "\)");
}
function PHA_ReplaceAll(str, oldStr, newStr) {
    var reg = new RegExp(oldStr,"g");
    return str.replace(reg, newStr);
}