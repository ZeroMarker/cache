/**
 * FileName: insu.rpt.opdivmxtj.js
 * Anchor: DingSH ZYW
 * Date: 2020-03-19
 * Description: ����ҽ����ϸͳ�Ʊ�
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
		SRC: 'dhccpmrunqianreport.csp?reportName=InsuOPDivMXTJ.rpx'
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

//��ʼ��Button�¼�
function InitButton()
{
   //�ǼǺŻس�
   $("#PapmiNo").keydown( function(e){ 
      if (e.keyCode==13)
        {
           var PapmiNo=getValueById('PapmiNo')
           var tmpPapmiNo=PapmiNo;
	       if (tmpPapmiNo!="")
		    {
	          var regNoLength=10-PapmiNo.length;     //�ǼǺŲ���   	
		      for (var i=0;i<regNoLength;i++){
			    tmpPapmiNo="0"+tmpPapmiNo;			
	         	}
		    }
           setValueById('PapmiNo',tmpPapmiNo)         //�ǼǺŲ�ȫ���д
        }
   }); 
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
	setValueById('cbStates',"");
	setValueById('cbInsuPatType',"");
	setValueById('PapmiNo',"");
    setValueById('InvNo',"");
	setValueById('InsuId',"");
	setValueById('FileNo',"");
	setValueById('InName',"");
    setValueById('cbDivFlag',"");
	
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
    	panelHeight:'auto',
    	multiple:true, 
    	rowStyle:'checkbox', 
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="web.INSUDicDataCom"
	    	param.QueryName="QueryDic"
	    	param.ResultSetType="array";
	    	if($("#cbInsuType").combobox("getText").indexOf("����")!="-1"){
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
	    	 $(this).combobox("select",dary[indexed].cCode) //����ƶ�ѡ��һ��
	    	}
	    	 
	    	}
	    	
	});
	
}

//��ʼ����Ա���
//���  OPIPFlag��OP:����, IP: "סԺ" ,"":ȫ��
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
	    	 $(this).combobox("select",dary[indexed].cCode) //����ƶ�ѡ��һ��
	    	}
	    	 
	    	}
	    	
	});
	
}


//��ʼ��ͳ����
//���  OPIPFlag��OP:����, IP: "סԺ" ,"":ȫ��
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
	    	if($("#cbInsuType").combobox("getText").indexOf("����")!="-1"){
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
	    	 $(this).combobox("select",dary[indexed].cCode) //����ƶ�ѡ��һ��
	    	}
	    	 
	    	}
	    	
	    	
	});
	
}


//��ʼ������״̬
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
    	data:[{cCode:'I',cDesc:'����'},{cCode:'B',cDesc:'������'},{cCode:'S',cDesc:'����'},{cCode:'D',cDesc:'Ԥ����'}]
    	
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