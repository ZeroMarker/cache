//名称    DHCPEPreDate.hisui.js
//功能  预约管理
//创建    2018.10.17
//创建人  yupeng
$(function(){
    
    //查询
    $("#BFind").click(function() {  
        BFind_click();      
        });
       
   
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

function SetPreDate(e)
{
    
    var DateStr=e.id;
    var Arr=DateStr.split("^");
    var UserFlag=Arr[2];
    
    if(UserFlag=="1"){
        return false;
    }
    
   var checkedRadioObj = $("input[name='PreTime']:checked");
   var PreTime=checkedRadioObj.val()
   
    
    
    parent.SetBeginDate(Arr[1],PreTime);
    parent.$('#PreDateWin').window('close');
    window.close();
    
}

function BFind_click()
{
    
    var Month=$("#Month").datebox('getValue');
    if(Month==""){  var  Month=$zd(+$h,3);}
     $('#Month').datebox('setValue',Month);
      lnk="dhcpepredate.hisui.csp"
          +"?Month="+Month+"&PreIADMID="+PreIADMID;
        
        $('#Month').datebox('setValue',Month);
         window.location.href=lnk
    }