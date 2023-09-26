/**
 * FileName: insu.rpt.opdivmxgrpbyinsutypetj.js
 * Anchor: YuanDC
 * Date: 2020-03-19
 * Description: 门诊医保类型汇总表
 */
 var INSURPT_CONSTANT = {
	//公共SESSION
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	IFRAME: {
		//定义报表URL+报表文件
		SRC: 'dhccpmrunqianreport.csp?reportName=InsuOPDivMXGrpByInsuTypeTJ.rpx'
	}
};

$(document).ready(function ()
{
	initQueryMenu();
});

function initQueryMenu() {
	
	//#1 初始化医保类型
	InitInsuTypeCmb();
	
    //#2 初始化Button事件
    InitButton();
       
	//#3 初始化iframe
	$('#report').attr('src', INSURPT_CONSTANT.IFRAME.SRC);
	
	
	
}

function scanReport() {

    var StDate=getValueById('StDate') ;
    var EndDate=getValueById('EndDate') ;
	var InsuType=getValueById('cbInsuType') ;
	var DivFlag="I"
    var HisAdmType="O"
    var InsuTypeDesc=$HUI.combobox("#cbInsuType").getText();
    
	var url = INSURPT_CONSTANT.IFRAME.SRC + '&StDate=' + StDate + '&EndDate=' + EndDate+ '&InsuType=' + InsuType+ '&DivFlag=' + DivFlag+ '&HisAdmType=' + HisAdmType;
		url +='&InsuTypeDesc=' + InsuTypeDesc + '&HOSPID=' + INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	$('#report').attr('src', url);
	
}

//初始化Button事件
function InitButton()
{
	
	//查询事件  
   $HUI.linkbutton('#QueryBT',{
      onClick: function()
           {
              scanReport();
            }
       });
   //清屏事件
   $HUI.linkbutton('#ClearBT',{
           onClick: function()
           {
             Clear_click();
            }
       });
	
	setDefDateValue();
	}
	
	
	
//清屏
function Clear_click()
{
	setDefDateValue();
	setValueById('cbInsuType',"");
	
	
}
	
	
	
//初始化医保类型
function InitInsuTypeCmb()
{
	$HUI.combobox("#cbInsuType",{
		url:$URL,
		editable:false,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:100,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="web.INSUDicDataCom";
	    	param.QueryName="QueryDic";
	    	param.ResultSetType="array";
	    	param.Type="DLLType";
	    	param.HospDr=INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	    	param.Code="";
	    },
    	loadFilter:function(data){
			for(var i in data){
				if(data[i].cDesc == "全部"){
					data.splice(i,1);
				}
			}
			return data;
	    },
    	onLoadSuccess:function(){
	    	var dary=$(this).combobox("getData")
	    	var cnt=dary.length
	    	},
	    	onSelect:function(rec)
	    	{
		    }
	});
}

/**
* 日期默认设置
*/
function setDefDateValue() {
	var curDateTime =$.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "FormDateTime"}, false);
	var myAry = curDateTime.split(/\s+/);
	setValueById("StDate", myAry[0]); 
	setValueById("EndDate", myAry[0]);
}