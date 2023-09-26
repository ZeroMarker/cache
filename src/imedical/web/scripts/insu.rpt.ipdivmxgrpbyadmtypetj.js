/**
 * FileName: insu.rpt.ipdivmxgrpbyadmtypetj.js
 * Anchor: XS
 * Date: 2020-03-19
 * Description: סԺҽ��������ͳ��
 */
 var INSURPT_CONSTANT = {
	//����SESSION
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	IFRAME: {
		//���屨��URL+�����ļ�
		SRC: 'dhccpmrunqianreport.csp?reportName=InsuIPDivMXGrpByAdmTypeTJ.rpx'
	}
};

$(document).ready(function ()
{
	initQueryMenu();
});

function initQueryMenu() {
	
	//#1 ��ʼ��ҽ������
	InitInsuTypeCmb();
	
    //#2 ��ʼ��Button�¼�
    InitButton();
       
	//#3 ��ʼ��iframe
	$('#report').attr('src', INSURPT_CONSTANT.IFRAME.SRC);
	
	
	
}

function scanReport() {

    var StDate=getValueById('StDate') ;
    var EndDate=getValueById('EndDate') ;
	var InsuType=getValueById('cbInsuType') ;
	var DivFlag="I"
    var HisAdmType="I"
    var InsuAdmType=getValueById('cbInsuAdmType') ;
    var InsuTypeDesc=$HUI.combobox("#cbInsuType").getText();
	var url = INSURPT_CONSTANT.IFRAME.SRC + '&StDate=' + StDate + '&EndDate=' + EndDate+ '&InsuType=' + InsuType+ '&DivFlag=' + DivFlag+ '&HisAdmType=' + HisAdmType + '&InsuAdmType=' + InsuAdmType+ '&InsuTypeDesc=' + InsuTypeDesc;
		url += '&HOSPID=' + INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	$('#report').attr('src', url);
	
}

//��ʼ��Button�¼�
function InitButton()
{
	
	//��ѯ�¼�  
   $HUI.linkbutton('#QueryBT',{
      onClick: function()
           {
              scanReport();
            }
       });
   //�����¼�
   $HUI.linkbutton('#ClearBT',{
           onClick: function()
           {
             Clear_click();
            }
       });
	
	setDefDateValue();
	}
	
	
	
//����
function Clear_click()
{
	setDefDateValue();
	setValueById('cbInsuType',"");
	setValueById('cbInsuAdmType',"");
}
	
	
	
//��ʼ��ҽ������
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
				if(data[i].cDesc == "ȫ��"){
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
		    	InitYLLBCmb("IP");
		    	
		    }
	});
}


//��ʼ��ҽ�����
//���  OPIPFlag��OP:����, IP: "סԺ" ,"":ȫ��
function InitYLLBCmb(OPIPFlag)
{
	var indexed=-1
	$HUI.combobox("#cbInsuAdmType",{
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
	    	param.Type=("AKA130"+getValueById('cbInsuType'));
	    	param.HospDr=INSURPT_CONSTANT.SESSION.HOSP_ROWID;
	    	param.Code="";
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
	    	 $(this).combobox("select",dary[indexed].cCode) //����ƶ�ѡ��һ��
	    	}
	    	 
	    	},
	    	onSelect:function(rec)
	    	{
		    	//$.messager.alert("��ʾ","��ѡ���ҽ������:"+rec.cCode, 'info');
		    }
	    	
	});
	
}

/**
* ����Ĭ������
*/
function setDefDateValue() {
	var curDateTime =$.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "FormDateTime"}, false);
	var myAry = curDateTime.split(/\s+/);
	setValueById("StDate", myAry[0]); 
	setValueById("EndDate", myAry[0]);
}