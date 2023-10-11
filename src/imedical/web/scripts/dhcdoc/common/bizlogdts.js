/*
Creater��	Qujian
CreateDate��2023-03-10
FileName��	scripts/dhcdoc/common/bizlogdts.js
Description������DTSǰ����㣬���ڵ�ҳ����õ�ǰ�����

����˵��:
	�� AddOnelog��ǰ���������
		�����÷�ʽ��DTSLog.AddOnelog(BizCode,BizMainId,BizId,BizJson,UserCode)
	�� Submitlog���ύ�������
		�����÷�ʽ��DTSLog.Submitlog();
*/
var DTSLog=(function(){
	defaultDataCache=3
	function AddOnelog(BizCode,BizMainId,BizId,BizJson,UserCode){
		var ParamsArr=new Array();
		var CurDate=new Date();
		var NowDate=""
		var Year=CurDate.getFullYear()
		var Morth=CurDate.getMonth()+1
		var Day=CurDate.getDay()
		var NowTime=CurDate.getHours()+":"+CurDate.getMinutes()+":"+CurDate.getSeconds()
		if (defaultDataCache==3){
			NowDate=Year+"-"+Morth+"-"+Day
			}else{
			NowDate=Day+"/"+Morth+"/"+Year	
		}
		var OneAddLog={
			'BizCode':BizCode,
			'BizMainId':BizMainId,
			'BizId':BizId,
			'BizJson':BizJson,
			'UserCode':UserCode,
			'BizDate':NowDate,
			'BizTime':NowTime
			}
		ParamsArr =$.data(document.body,"DTSLog");
		if (ParamsArr){
			ParamsArr[ParamsArr.length]=OneAddLog;
		}else{
			var ParamsArr=new Array();
			ParamsArr[0]=OneAddLog;
		}
		jQuery.data(document.body,"DTSLog",ParamsArr);
		return true;
		};
	function Submitlog(){
		var BizLogDTSJsonObj=$.data(document.body,"DTSLog")
		var rtn=$.cm({
			ClassName:'DHCDoc.Log.BizLogDTS',
			MethodName:'JSBizLogDTSInsert',
			BizLogDTSJson:JSON.stringify(BizLogDTSJsonObj),
			dataType:'text'
		},false);
		jQuery.data(document.body,"DTSLog","");
		return true;
		};
	function ClearDTSLog(){
		jQuery.data(document.body,"DTSLog","");
		return true;
		}
	return {
		"AddOnelog":AddOnelog,
		"Submitlog":Submitlog,
		"ClearDTSLog":ClearDTSLog
	}
	})();