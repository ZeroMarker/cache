
//名称	DHCPEHadCheckedList.js
//功能	名单信息
//组件	DHCPEHadCheckedList	
//创建	2018.09.10
//创建人  xy

/*
var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
        $.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
                //隐藏合计行图标 
              hiddenTableIcon("DHCPEHadCheckedList","TPAADM","TItemlist");
            }
});
*/

function BodyLoadHandler() {

	var obj;
	
	  //设置按钮大小
	$("#BFind").css({"width":"116px"});

	//打印名单
	obj=document.getElementById("Print");
	if (obj) {obj.onclick=Print_Click;}
	
	//查询
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}
	
	$("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				BFind_Click();
			}
			
        }); 
	
	$("#Name").keydown(function(e) {	
			if(e.keyCode==13){
				BFind_Click();
			}
			
        }); 

	inti();

	//隐藏合计行图标
	$("#tDHCPEHadCheckedList").datagrid('options').view.onAfterRender = function(){
	     	  
	 	      //隐藏合计行图标 
               hiddenTableIcon("DHCPEHadCheckedList","TPAADM","TItemlist");
                 
			   //重新设置datagrid的高度
			   if ($('#tDHCPEHadCheckedList').length==0) return ;
				var h = $(window).height();
				var offset = $('#tDHCPEHadCheckedList').closest('.datagrid').offset();
 				if (!offset) return ;
					$('#tDHCPEHadCheckedList').datagrid('resize',{height:parseInt(h-offset.top-13)});
 	           
		 } 
	
		
	
}


function inti()
{
	var Type=getValueById("HadCheckType");
	if(Type!="Y"){
			$("#cCheckItemStatus").css('display','none');//隐藏
			$("#CheckItemStatus").next(".combo").hide();//combobox隐藏

		var obj=document.getElementById("cTitle");
		if (obj)
		{
		   obj.innerText="未检人员信息";
		

		}
	}
	if(Type=="C"){
			$("#cCheckItemStatus").css('display','none');//隐藏
			$("#CheckItemStatus").next(".combo").hide();//combobox隐藏
			$("#cChargeStatus").css('display','none');//隐藏
			$("#ChargeStatus").next(".combo").hide();//combobox隐藏
	}

}

function BFind_Click()
{
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=getValueById("RegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { 
		iRegNo=RegNoMask(iRegNo);
		$("#RegNo").val(iRegNo);
	}
	
	 var iName=getValueById("Name");
	 var iGroupID=getValueById("GroupID");
	 var iHadCheckType=getValueById("HadCheckType");
	 var iDateFrom=getValueById("DateFrom");
	 var iDateTo=getValueById("DateTo");
	 var iDepartName=getValueById("DepartName");
	 var iChargeStatus=getValueById("ChargeStatus");
   	if(iChargeStatus==undefined){iChargeStatus="";}
	var iCheckItemStatus=getValueById("CheckItemStatus");
   	if(iCheckItemStatus==undefined){iCheckItemStatus="";}

	
  	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEHadCheckedList"
			+"&RegNo="+iRegNo
			+"&GroupID="+iGroupID
			+"&HadCheckType="+iHadCheckType
			+"&DateFrom="+iDateFrom
			+"&DateTo="+iDateTo
			+"&DepartName="+iDepartName
			+"&Name="+iName
			+"&ChargeStatus="+iChargeStatus
			+"&CheckItemStatus="+iCheckItemStatus
			;
   // alert(lnk)
    $("#tDHCPEHadCheckedList").datagrid('load',{ComponentID:55979,RegNo:iRegNo,GroupID:iGroupID,HadCheckType:iHadCheckType,DateFrom:iDateFrom,DateTo:iDateTo,DepartName:iDepartName,Name:iName,ChargeStatus:iChargeStatus,CheckItemStatus:iCheckItemStatus});
	           
    //location.href=lnk; 
}
function PrintNew_Click()
{

	var obj,HadCheckType="",DateFrom="",DateTo=""
	var ret="";
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEHadCheckedList.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"+
        "xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells(2,16)).mergecells=true;"+ 
        "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,16)).mergecells=true;"+ 
        "xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells(2,16)).Borders.LineStyle='1';"+ 
        "xlSheet.Range(xlSheet.Cells(3,1),xlSheet.Cells(3,16)).Borders.LineStyle='1';"
      
         var encmethObj=document.getElementById("PrintInfoBox");
    	if (encmethObj) encmeth=encmethObj.value;
    
       Rows=tkMakeServerCall("web.DHCPE.PreGADM","GetPostionNum");
		for(i=0;i<Rows;i++)
		{
			
		      var OneInfo=cspRunServerMethod(encmeth,i+1)
		      var Info=OneInfo.split("^");
		      var HadCheckType=Info[7];
         	  
			  if (HadCheckType=="Y"){ HadCheckType="已检人员名单"}
			  else if (HadCheckType=="N"){ HadCheckType="未检人员名单"}
			  else if (HadCheckType=="C"){ HadCheckType="取消体检人员名单"}
          
          if(ret==""){
	          var k=4+i;
	          var n=i+1;
	           ret="xlSheet.Cells("+k+",1).Value='"+n+"';"+
	           "xlSheet.Cells("+k+",2).Value='"+Info[2]+"';"+  		//登记号
	           "xlSheet.Cells("+k+",3).Value='"+Info[3]+"';"+  		//姓名
	           "xlSheet.Cells("+k+",4).Value='"+Info[4]+"';"+  		//性别
	           "xlSheet.Cells("+k+",5).Value='"+Info[5]+"';"+   	//分组6
	           "xlSheet.Cells("+k+",6).Value='"+Info[10]+"';"+   	//年龄5
	           "xlSheet.Cells("+k+",7).Value='"+Info[1]+"';"+    	//部门6
	           "xlSheet.Cells("+k+",8).Value='"+Info[6]+"';"+  		//金额7
	           "xlSheet.Cells("+k+",9).Value='"+Info[11]+"';"+  	//自费金额7
	           "xlSheet.Cells("+k+",10).Value='"+Info[12]+"';"+   	//公费项目金额7
	           "xlSheet.Cells("+k+",11).Value='"+Info[13]+"';"+  	//套餐金额7
		     	"xlSheet.Cells("+k+",12).Value='"+Info[14]+"';"+    	//移动电话
	           "xlSheet.Cells("+k+",13).Value='"+Info[15]+"';"+  		//到达时间
	           "xlSheet.Cells("+k+",14).Value='"+Info[16]+"';"+  	//证件类型
	           "xlSheet.Cells("+k+",15).Value='"+Info[17]+"';"+   	//证件号
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//报告状态
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//报告状态
	           "xlSheet.Cells(1,1).Value='"+Info[0]+HadCheckType+"';"+
	           "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,16)).HorizontalAlignment= -4108;"+  //居中
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",6)).HorizontalAlignment= -4108;"+
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",16)).Borders.LineStyle='1';"
		       
          }else{
	          var k=4+i;
	          var n=i+1;
	           ret=ret+"xlSheet.Cells("+k+",1).Value='"+n+"';"+
	           "xlSheet.Cells("+k+",2).Value='"+Info[2]+"';"+  		//登记号
	           "xlSheet.Cells("+k+",3).Value='"+Info[3]+"';"+  		//姓名
	           "xlSheet.Cells("+k+",4).Value='"+Info[4]+"';"+  		//性别
	           "xlSheet.Cells("+k+",5).Value='"+Info[5]+"';"+   	//分组6
	           "xlSheet.Cells("+k+",6).Value='"+Info[10]+"';"+   	//年龄5
	           "xlSheet.Cells("+k+",7).Value='"+Info[1]+"';"+    	//部门6
	           "xlSheet.Cells("+k+",8).Value='"+Info[6]+"';"+  		//金额7
	           "xlSheet.Cells("+k+",9).Value='"+Info[11]+"';"+  	//自费金额7
	           "xlSheet.Cells("+k+",10).Value='"+Info[12]+"';"+   	//公费项目金额7
	           "xlSheet.Cells("+k+",11).Value='"+Info[13]+"';"+  	//套餐金额7
		     	"xlSheet.Cells("+k+",12).Value='"+Info[14]+"';"+    	//移动电话
	           "xlSheet.Cells("+k+",13).Value='"+Info[15]+"';"+  		//到达时间
	           "xlSheet.Cells("+k+",14).Value='"+Info[16]+"';"+  	//证件类型
	           "xlSheet.Cells("+k+",15).Value='"+Info[17]+"';"+   	//证件号
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//报告状态
	           "xlSheet.Cells("+k+",16).Value='"+Info[18]+"';"+  	//报告状态
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",6)).HorizontalAlignment= -4108;"+
		      "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",16)).Borders.LineStyle='1';"
		       
         	  }
		}
		
         	  var Str=Str+ret+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
            "xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(Str)
		//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ;
  
 
	
}
function Print_Click()
{ 
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    var obj,HadCheckType="",DateFrom="",DateTo=""
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEHadCheckedList.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	//alert(Templatefilepath)
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	
	
	 xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,16)).Borders.LineStyle=1; 
     xlsheet.Range(xlsheet.Cells(3,1),xlsheet.Cells(3,16)).Borders.LineStyle=1;
     xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,16)).mergecells=true;
     xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,16)).mergecells=true;

	

   
    var encmethObj=document.getElementById("PrintInfoBox");
    if (encmethObj) encmeth=encmethObj.value;
    
   
    Rows=tkMakeServerCall("web.DHCPE.PreGADM","GetPostionNum");
    for(i=0;i<Rows;i++)
		{
			//Position_"^"_GroupDesc_"^"_TeamDesc_"^"_IRegNo_"^"_IName_"^"_ISexDRName_"^"_IAge_"^"_IDepName_"^"_HadCheckType_"^"_DateFrom_"^"_DateTo_"^"_OneAmount_"^"_IAmt_"^"_FItemAmt_"^"_FEntAmt
		      
		      var OneInfo=cspRunServerMethod(encmeth,i+1)
		      var Info=OneInfo.split("^");
		      var HadCheckType=Info[7];
         	  
			  if (HadCheckType=="Y"){ HadCheckType="已检人员名单"}
			  else if (HadCheckType=="N"){ HadCheckType="未检人员名单"}
			  else if (HadCheckType=="C"){ HadCheckType="取消体检人员名单"}


		      
		      xlsheet.cells(4+i,1).Value=i+1;
		      xlsheet.cells(4+i,2).Value=Info[2];	//登记号
		      xlsheet.cells(4+i,3).Value=Info[3]; 	//姓名
		      xlsheet.cells(4+i,4).Value=Info[4]; 	//性别
		      xlsheet.cells(4+i,5).Value=Info[5]; 	//分组6
		      xlsheet.cells(4+i,6).Value=Info[10];	//年龄5
		      xlsheet.cells(4+i,7).Value=Info[1];	//部门6
		      xlsheet.cells(4+i,8).Value=Info[6]; 	//金额7
		      xlsheet.cells(4+i,9).Value=Info[11]; 	//自费金额7
		      xlsheet.cells(4+i,10).Value=Info[12]; 	//公费项目金额7
		      xlsheet.cells(4+i,11).Value=Info[13]; 	//套餐金额7
			  xlsheet.cells(4+i,12).Value=Info[14]; //移动电话
			  xlsheet.cells(4+i,13).Value=Info[15]; //到达时间
			  xlsheet.cells(4+i,14).Value=Info[16]; //证件类型
              xlsheet.cells(4+i,15).Value=Info[17]; //证件号
              xlsheet.cells(4+i,16).Value=Info[18]; //报告状态

		      //xlsheet.cells(3,7).Value="部门"; 
              xlsheet.cells(1,1).Value=Info[0]+HadCheckType; 
             xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,6)).HorizontalAlignment =-4108;//居中
             xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,16)).HorizontalAlignment =-4108;//居中
         	// xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(9).LineStyle=1;//居中
         	 // xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(3).LineStyle=1;
         	  xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,16)).Borders.LineStyle=1; }
   //xlsheet.SaveAs("d:\\团体人员名单.xls")
   xlApp.Visible = true;
   xlApp.UserControl = true;
   }else{
	  PrintNew_Click()
  } 

     

}



document.body.onload = BodyLoadHandler;
