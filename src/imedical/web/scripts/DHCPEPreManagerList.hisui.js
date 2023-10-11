//名称	DHCPEPreManagerList.hisui.js
//功能  预约管理
//创建	2018.10.17
//创建人  xy
$(function(){
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
       
     //限额模板
	$("#BTemplateManager").click(function() {	
		BTemplateManager_click();		
        }); 
        
   // SetDefault();
   
})

function SetDefault()
{
	var curr_time = new Date();
	function myformatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;  
	}  
	$('#Month').datebox('setValue', myformatter(curr_time));
      
}

function ShowPreManagerInfo(e)
{
	var DateStr=e.id;
	//var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreManager'+"&DateStr="+DateStr;
	var lnk="dhcpepremanager.hisui.csp?DateStr="+DateStr;
	websys_lu(lnk,false,'width=950,height=545,hisui=true,title=预约管理信息')
}

function BTemplateManager_click()
{
	//var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreTemplate";
	//window.open(str,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=50,left=100,width=1200,height=600");
	//websys_lu(str,false,'hisui=true,title=预约限额模板维护')
	var lnk="dhcpe.pretemplate.csp";
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1280,height=700,hisui=true,title=预约限额模板维护')

	
}

function BFind_click()
{
	
	var Month=$("#Month").datebox('getValue');
	if(Month == "") {
		$.messager.alert("提示", "请先选择日期！", "info");
		return false;
	}
	
    var TabInfo = $.m({ClassName:"web.DHCPE.PreManager", MethodName:"OutMainHISUI",Month:Month,CTLOCID:"",OutFlag:"Return"}, false);
	$("#PreManagerQueryTab").empty();
	$("#PreManagerQueryTab").append(TabInfo); 

	/*
	if(Month==""){  var  Month=$zd(+$h,3);}
     $('#Month').datebox('setValue',Month);
	  lnk="dhcpepremanagerlist.hisui.csp"
          +"?Month="+Month+"&CTLOCID="+"";
		
		$('#Month').datebox('setValue',Month);
		 window.location.href=lnk
	//location.href=lnk; 
	
	*/

}