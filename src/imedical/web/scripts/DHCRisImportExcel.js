//DHCRisExamSortPropertySet.js
var SelectedRow="-1";
var combo_isSort;
var combo_isAuto;

var $=function(Id){
	return document.getElementById(Id);
}


function BodyLoadHandler()
{
	var ImportObj=$("Import");
	if (ImportObj)
	{
		ImportObj.onclick=Import_click;
	}
	
	var ArcItmMemoObj=$("ImportArcItmMemo");
	if (ArcItmMemoObj)
	{
		ArcItmMemoObj.onclick=ImportArcItmMemo_click;
	}
}

function Import_click()
{
	var filePath=trim( $("excelPath").value); 
    if(filePath==null || filePath==""){  
        alert("请选择文件!");  
        return ;  
    }  
    
    var fso;
   	fso = new ActiveXObject("Scripting.FileSystemObject");
   	if (!fso.FileExists(filePath))
   	{
	   	alert(filePath+" 不存在!");
	   	return;
   	}
     
      
    try
    {  
        var test = new ActiveXObject("Excel.application");  
        test.Quit();  
        CollectGarbage();;  
    }catch(e){  
        alert('请将您浏览器Internet选项中的"对没有标记为安全的ActiveX控件进行初始化和脚本运行"设置为"启用"或"提示"/n/n然后刷新本页登陆');    
        //CollectGarbage();  
        return;  
    }  
    
    
    var oXL = new ActiveXObject("Excel.application");   
    var oWB = oXL.Workbooks.open(filePath);  
    oWB.worksheets(1).select();   
    var oSheet = oWB.ActiveSheet;  
    
    ConFlag=confirm('您确认要导入医嘱项目与服务组设置数据吗?');
    if (ConFlag==false){return}
    try
    {  
        for(var h=2;h<1000;h++)
        {
	        var insertInfo="";
	        var hasValue=0;
            for(var i=1;i<10;i++)
            {
	            var infoItem=""  
                if(oSheet.Cells(h,i).value !="null" && oSheet.Cells(h,i).value!=undefined)
                {
	                hasValue=1;
	                infoItem=oSheet.Cells(h,i).value;
                }
                if ( i==1)
                	insertInfo=infoItem;
                else
                	insertInfo=insertInfo+"^"+infoItem;
            } 
            //alert(insertInfo);
            if ( hasValue==0)
            	break;
            //alert(h); 
            var ImportFunction=$("ImportFunction").value;
			var ret=cspRunServerMethod(ImportFunction,insertInfo);
			if ( ret!=0)
			{
				alert(insertInfo+",插入失败code="+ret);
			}
        }  
        
        if (ret==0)
          alert("导入成功!");
    }
    catch(e)
    {  
        oXL.Quit();    
    }   
    oXL.Quit();  
 
    CollectGarbage();  
    //excelWin.hide();  
	//return  Find_click();
}

function ImportArcItmMemo_click()
{
		var filePath=trim( $("excelPath").value); 
    if(filePath==null || filePath==""){  
        alert("请选择文件!");  
        return ;  
    }  
    
    var fso;
   	fso = new ActiveXObject("Scripting.FileSystemObject");
   	if (!fso.FileExists(filePath))
   	{
	   	alert(filePath+" 不存在!");
	   	return;
   	}
     
      
    try
    {  
        var test = new ActiveXObject("Excel.application");  
        test.Quit();  
        CollectGarbage();;  
    }catch(e){  
        alert('请将您浏览器Internet选项中的"对没有标记为安全的ActiveX控件进行初始化和脚本运行"设置为"启用"或"提示"/n/n然后刷新本页登陆');    
        //CollectGarbage();  
        return;  
    }  
    
    
    var oXL = new ActiveXObject("Excel.application");   
    var oWB = oXL.Workbooks.open(filePath);  
    oWB.worksheets(1).select();   
    var oSheet = oWB.ActiveSheet;  
    
    ConFlag=confirm('您确认要导入医嘱项目与注意事项模板设置数据吗?');
    if (ConFlag==false){return}
    try
    {  
        for(var h=2;h<1000;h++)
        {
	        var insertInfo="";
	        var hasValue=0;
            for(var i=1;i<3;i++)
            {
	            var infoItem=""  
                if(oSheet.Cells(h,i).value !="null" && oSheet.Cells(h,i).value!=undefined)
                {
	                hasValue=1;
	                infoItem=oSheet.Cells(h,i).value;
                }
                if ( i==1)
                	insertInfo=infoItem;
                else
                	insertInfo=insertInfo+"^"+infoItem;
            } 
            //alert(insertInfo);
            if ( hasValue==0)
            	break;
            //alert(h); 
 
			var ret=tkMakeServerCall("web.DHCRisCommFunctionEx","ImportNewMemo", insertInfo);
			if ( ret!=0)
			{
				alert(insertInfo+",插入失败code="+ret);
			}
        }  
        
        if (ret==0)
          alert("导入成功!");
    }
    catch(e)
    {  
        oXL.Quit();    
    }   
    oXL.Quit();  
 
    CollectGarbage();  
    //excelWin.hide();  
	//return  Find_click();

}
function trim(str)
{ //删除左右两端的空格  
	return str.replace(/(^\s*)|(\s*$)/g, "");  
} 




document.body.onload = BodyLoadHandler;


