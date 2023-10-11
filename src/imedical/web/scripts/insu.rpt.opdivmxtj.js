/**
 * FileName: insu.rpt.opdivmxtj.js
 * Anchor: DingSH ZYW
 * Date: 2020-03-19
 * Description: 门诊医保明细统计表
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
		SRC: 'dhccpmrunqianreport.csp?reportName=InsuOPDivMXTJ.rpx'
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
	var DivFlag=$HUI.combobox('#cbDivFlag').getValues()
    var HisAdmType="O"
    var InsuAdmType=$HUI.combobox('#cbInsuAdmType').getValues() ;
        InsuAdmType=InsuAdmType.join("|").toString();
	var InsuPatType=$HUI.combobox('#cbInsuPatType').getValues() ;
	    InsuPatType=InsuPatType.join("|").toString();
	var InsuCenterID=$HUI.combobox('#cbStates').getValues();
	    InsuCenterID=InsuCenterID.join("|").toString();
	var RepType="" ;
	var InvNo=getValueById('InvNo');
	var InsuId=getValueById('InsuId');
	var InName=getValueById('InName');
	var FileNo=getValueById('FileNo'); 
	var PapmiNo=getValueById('PapmiNo');
	var InsuTypeDesc=$HUI.combobox("#cbInsuType").getText();
	var url = INSURPT_CONSTANT.IFRAME.SRC + '&StDate=' + StDate + '&EndDate=' + EndDate+ '&InsuType=' + InsuType+ '&DivFlag=' + DivFlag+ '&HisAdmType=' + HisAdmType;
		url += '&InsuAdmType=' + InsuAdmType + '&InsuPatType=' + InsuPatType + '&InsuCenterID=' + InsuCenterID + '&RepType=' + RepType + '&InvNo=' + InvNo;
		url += '&InsuId=' + InsuId + '&InName=' + InName + '&FileNo=' + FileNo + '&PapmiNo=' + PapmiNo + '&InsuTypeDesc=' + InsuTypeDesc;
		url += '&HOSPID=' + INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	$('#report').attr('src', url);
	
}

//初始化Button事件
function InitButton()
{
   //登记号回车
   $("#PapmiNo").keydown( function(e){ 
      if (e.keyCode==13)
        {
           var PapmiNo=getValueById('PapmiNo')
           var tmpPapmiNo=PapmiNo;
	       if (tmpPapmiNo!="")
		    {
	          var regNoLength=10-PapmiNo.length;     //登记号补零   	
		      for (var i=0;i<regNoLength;i++){
			    tmpPapmiNo="0"+tmpPapmiNo;			
	         	}
		    }
           setValueById('PapmiNo',tmpPapmiNo)         //登记号补全后回写
        }
   }); 
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
	setValueById('cbInsuAdmType',"");
	setValueById('cbStates',"");
	setValueById('cbInsuPatType',"");
	setValueById('PapmiNo',"");
    setValueById('InvNo',"");
	setValueById('InsuId',"");
	setValueById('FileNo',"");
	setValueById('InName',"");
    setValueById('cbDivFlag',"");
	
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
	    	InitDivFlagCmb();
	    	},
	    	onSelect:function(rec)
	    	{
		    	InitYLLBCmb("OP");
		    	InitStatesCmb("") ;
		    	InitPatTypeCmb("") ;
		    	
		    }
	});
}


//初始化医疗类别
//入参  OPIPFlag：OP:门诊, IP: "住院" ,"":全部
function InitYLLBCmb(OPIPFlag)
{
	var indexed=-1
	$HUI.combobox("#cbInsuAdmType",{
		url:$URL,
		editable:false,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:'auto',
    	multiple:true, 
    	rowStyle:'checkbox', 
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="web.INSUDicDataCom"
	    	param.QueryName="QueryDic"
	    	param.ResultSetType="array";
	    	if($("#cbInsuType").combobox("getText").indexOf("国家")!="-1"){
				param.Type=("med_type"+getValueById('cbInsuType'));
			}else{
				param.Type=("AKA130"+getValueById('cbInsuType'));
			} ;
	    	param.HospDr=INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	    	param.Code=""
	    },
    	
    	loadFilter:function(data){
	    	var j=0
	    	newdata=new Array() 
			for(var i in data){
				if (((data[i].DicOPIPFlag==OPIPFlag)||(""==OPIPFlag))&&(data[i].cCode != "")){
					newdata.push(data[i])
					if (data[i].DicDefaultFlag=="Y"){
						indexed=j;
						}
					j=j+1
				}
			}
			return newdata;
	    },
    	onLoadSuccess:function(){
	    	var dary=$(this).combobox("getData")
	    	var cnt=dary.length
	    	if (indexed>-1)
	    	{
	    	 $(this).combobox("select",dary[indexed].cCode) //如何制定选中一行
	    	}
	    	 
	    	}
	    	
	});
	
}

//初始化人员类别
//入参  OPIPFlag：OP:门诊, IP: "住院" ,"":全部
function InitPatTypeCmb(OPIPFlag)
{
	
	var indexed=-1
	$HUI.combobox("#cbInsuPatType",{
		url:$URL,
		editable:false,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:'auto',
    	multiple:true, 
    	rowStyle:'checkbox', 
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="web.INSUDicDataCom";
	    	param.QueryName="QueryDic";
	    	param.ResultSetType="array";
	    	param.Type=("AKC021"+getValueById('cbInsuType'));
	    	param.HospDr=INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	    	param.Code="";
	    },
    	
    	loadFilter:function(data){
	    	var j=0
	    	newdata=new Array() 
			for(var i in data){
				if (((data[i].DicOPIPFlag==OPIPFlag)||(""==OPIPFlag))&&(data[i].cCode != "")&&(typeof(data[i].cCode) != "undefined")){
					newdata.push(data[i])
					if (data[i].DicDefaultFlag=="Y"){
						indexed=j;
						}
					j=j+1
				}
			}
			return newdata;
	    },
    	onLoadSuccess:function(){
	    	var dary=$(this).combobox("getData")
	    	var cnt=dary.length
	    	if (indexed>-1)
	    	{
	    	 $(this).combobox("select",dary[indexed].cCode) //如何制定选中一行
	    	}
	    	 
	    	}
	    	
	});
	
}


//初始化统筹区
//入参  OPIPFlag：OP:门诊, IP: "住院" ,"":全部
function InitStatesCmb(OPIPFlag)
{
	
	var indexed=-1
	$HUI.combobox("#cbStates",{
		url:$URL,
		editable:true,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:150,  //'auto',
    	multiple:true, 
    	rowStyle:'checkbox', 
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="web.INSUDicDataCom";
	    	param.QueryName="QueryDic";
	    	param.ResultSetType="array";
	    	if($("#cbInsuType").combobox("getText").indexOf("国家")!="-1"){
				param.Type=("admdvs"+getValueById('cbInsuType'));
			}else{
				param.Type=("YAB003"+getValueById('cbInsuType'));
			} 
	    	//param.Type=("YAB003"+getValueById('cbInsuType'));
	    	param.HospDr=INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	    	param.Code=""
	    },
    	
    	loadFilter:function(data){
	    	var j=0
	    	newdata=new Array() 
			for(var i in data){
				if (((data[i].DicOPIPFlag==OPIPFlag)||(""==OPIPFlag))&&(data[i].cCode != "")&&(typeof(data[i].cCode) != "undefined")){
					newdata.push(data[i])
					if (data[i].DicDefaultFlag=="Y"){
						indexed=j;
						}
					j=j+1
				}
			}
			return newdata;
	    },
    	onLoadSuccess:function(){
	    	var dary=$(this).combobox("getData")
	    	var cnt=dary.length
	    	if (indexed>-1)
	    	{
	    	 $(this).combobox("select",dary[indexed].cCode) //如何制定选中一行
	    	}
	    	 
	    	}
	    	
	    	
	});
	
}


//初始化结算状态
function InitDivFlagCmb()
{
	
	var indexed=-1
	$HUI.combobox("#cbDivFlag",{
		editable:false,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:100,
    	multiple:true, 
    	rowStyle:'checkbox', 
    	data:[{cCode:'I',cDesc:'正常'},{cCode:'B',cDesc:'被冲销'},{cCode:'S',cDesc:'冲销'},{cCode:'D',cDesc:'预结算'}]
    	
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