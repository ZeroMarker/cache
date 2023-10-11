/// 编写者: 王鑫
/// 编写日期: 2020-09-27
/// 页面初始化函数
function initPageDefault()
{	
 $('#micrData').click(function(e)
  {
    micrDataImp();      /// 导入数据
  });
 $('#ShowData').click(function(e)
  {
    ShowData();      /// 展示数据
  });
		
}
function micrDataImp()
{	
    var efilepath = $("input[name=filepath]").val();
    //alert(efilepath.indexOf(".xls"))
    //if (efilepath.indexOf("fakepath") > 0) {alert("请在IE下执行导入！"); return; }
    if (efilepath.indexOf(".xls") <= 0) { alert("请选择excel表格文件！"); return; }
    //var kbclassname = ""  //类名
    var sheetcount = 1  //模板中表的个数
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('提示', '文件选择的不正确！');
        return;
    }
	try {
	        var oXL = new ActiveXObject("Excel.application");
	        var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	        $.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
	        return;
	}
    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
    $.messager.progress({title:'请稍后',msg:'数据正在导入中...'}); 
    var errMsg="",dicFlag=0;
    var CellValStr=""
    var count=0
    for (var j = 2; j <= rowcount; j++)
     {
       var cellVals=""
       for(var i=1;i<=colcount;i++){
             var cellValue = ""
            if (typeof (oSheet.Cells(j, i).value) == "undefined") {
             cellValue = "" }
           else {
             cellValue = oSheet.Cells(j, i).value}
          if(cellVals=="")
              {
               cellVals=cellValue
              }
          else
            {
	   cellVals=cellVals+"^"+cellValue
             }
          }
      if(CellValStr=="")
          {
               CellValStr=cellVals
           }
        else
          {
	          count++
	          readData(count,cellVals)  //excel数据存储
          }
     }
    detection()
    $.messager.progress('close')//数据导入完成关闭加载框
    clearFiles ()
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

//清空文件上传的路径 
function clearFiles ()
{
   var file = $("#filepath");
   file.after(file.clone().val(""));      
   file.remove();   	
}


///数据单独存储
function readData(count,cellVals){
	serverCall("web.DHCCKBSuited","InsertByData",{"count":count,"cellVals":cellVals})
	}
	
	///数据校验
function detection(){         
	serverCall("web.DHCCKBSuited","GetOrgMatchDiagExecute")
}

//比对数据结果展示
function ShowData(){
   $("#tbgrid").show();
   var grid= $("#tbgrid").datagrid({
		    url:$URL+"?ClassName=web.DHCCKBSuited&QueryName=GetList",
		    queryParams:{ Id:"" },
		    width:750,
		    height:600,
		    columns:[[
		       {field:"Id",hidden:true},
		       {field:"hisDiag",width:250,title:"诊断"},
		       {field:"icdCode",width:250,title:"Code"},
		       {field:"icdDiag",width:250,title:"匹配"}
		    ]],
		    fitColumns:true,
		    singleSelect:true,//多选,单选切换
		    rownumbers:true,//行号
		    pagination:true,//分页工具条
		    pageSize:20,
		    pageList:[20,40,60]
	    });
}



/// JQuery 初始化页面
$(function(){ initPageDefault(); })