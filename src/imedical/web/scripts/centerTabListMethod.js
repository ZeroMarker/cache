/*
*Creater:chenwenjun
*CreatDate:090505
*Desc:历次列表的操作函数
*/

//ajax从后台取权限	add bu zhuj on 2009-12-4
function getPower()
{
	Ext.Ajax.request({
		url: '../web.eprajax.ajaxGetPower.cls',
		timeout: parent.parent.timedOut,
		params: { episodeID: _EpisodeID, printTemplateDocId: _PrtTemplateDocID, templateDocId: _TemplateDocID, EPRNum: "", patientID: _PatientID},
		success: function(response, opts) {
			var obj = eval('[{' + response.responseText + '}]');
			canView = obj[0].canView;
			canSave = obj[0].canSave;
			canPrint = obj[0].canPrint;
			canCommit = obj[0].canCommit;
			canSwitch = obj[0].canSwitch;
			canSwitchTemplate = obj[0].canSwitchTemplate;
			canChiefCheck = obj[0].canChiefCheck;
			canAttendingCheck = obj[0].canAttendingCheck;
			printAfterCommit = obj[0].printAfterCommit;
			canExport = obj[0].canExport;
			setPower();
			
		},
		failure: function(response, opts) {				
			var obj = "获取权限列表错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;				
			alert(obj);
		}
	});
}


function PrintClickHandler() {
	/*
	if (GetChkSelectAllChecked())
	{
		alert('只有 显示全部 时方可打印！\n\n如要打印，请先将左上角 只显示<...> 的对勾去掉！')
		return false;
	}
	*/
	var objUCPrint =document.getElementById('UCPrint');
	
	if (objUCPrint) {
		var strInstances = "";
		var ckbPrintList = document.getElementById('EPRList').all['ckbPrint'];
		var instanceList = document.getElementById('EPRList').all['valueTr'];
		if (ckbPrintList == null){alert("历次列表无记录!"); return false;}
		if(ckbPrintList.length==undefined)
		{	
			//表示只有一条记录
			if(ckbPrintList.checked)
			{
				//判断是否是未完成的病历		add by zhuj on 2009-11-25
				if (ckbPrintList.statusCode == "unfinished")
				{
					alert('未"完成"的病历不能打印!');
					return false;
				}
				strInstances=instanceList.instanceid + ",";
			}
		}
		else
		{
			//add by zhuj on 2009-9-12
			var firstCkbPrintDocID = '-1';
			var ckbPrintListLength = ckbPrintList.length;
			for(var i=0; i < ckbPrintListLength; i++)
			{
				var curCkbPrint =ckbPrintList[i];
				if (curCkbPrint.checked)
				{
					//判断是否是未完成的病历		add by zhuj on 2009-11-25
					if (curCkbPrint.statusCode == "unfinished")
					{
						alert('未"完成"的病历不能打印!');
						return false;
					}
					if(firstCkbPrintDocID == '-1')
					{
						firstCkbPrintDocID = curCkbPrint.logDocID;
					}

					else if (firstCkbPrintDocID != curCkbPrint.logDocID)
					{
						alert('每次打印只能选择同一模板的数据!');
						return false;
					}			
				}
				else
				{
					continue;
				}			
			}

			

			var ckbPrintListLength = ckbPrintList.length;
			for(var i=0; i < ckbPrintListLength; i++)
			{
				var curCkbPrint =ckbPrintList[i];
				if (curCkbPrint.checked)
				{			
					var curInstanceID = instanceList[i].instanceid;
					if (curInstanceID) { strInstances += curInstanceID + ",";}			
				}
				else
				{
					continue;
				}			
			}
   
   		}

   		if (!(strInstances == "")) {
			var strResult = strInstances.substr(0, strInstances.length - 1);	

			var result = objUCPrint.PrintMultiple(_PatientID, _EpisodeID, strResult, _UserID, _PrtTemplateDocID);
			return result
   		}
		else {
			alert("请选择需要打印的条目");	
			return false
		}
  	}
}

//打开历次中的某一次
function OpenRecordClickHandler(episodeid, categoryid, profileid, instanceid, eprNum, chartID,  patientID, logRowID, templateDocID, prtDocID, lstTitle, happenDate) 
{
	parent.OpenRecordClickHandler(episodeid, categoryid, profileid, instanceid, eprNum, chartID,  patientID, logRowID,templateDocID, prtDocID, lstTitle, happenDate) ;
	//parent.showTab("multiple", "epr.newfw.epreditor.csp?EpisodeID=" + episodeid + "&CategoryID=" + categoryid + "&ProfileID=" + profileid + "&InstanceDataID=" + instanceid, 'epredit');			
}

//判断是否选中了“只显示”
function GetChkSelectAllChecked() 
{
	return Ext.getCmp('chkSelectAll').checked;		
}

//新建
function newList() {
    //edit by loo on 2010-7-28
    //修改内容：增加了一个判断“新建”按钮是否可按
    //修改原因：新增快捷键F2，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。
    if (Ext.getCmp('btnNew').disabled == false) {
        //debugger;
        var eprListNo = 1;
        var list = document.getElementById('EPRList').all['ckbPrint'];
        if (list) {
            eprListNo = list.length + 1;
        }
        parent.createEprListEdit(_PatientID, _EpisodeID, _CategoryID, _CategoryType, _ProfileID, _ProfileID, _TemplateID, _TemplateName, _TemplateDocID, eprListNo)
    }
}

//预览
function preview() {
    if (Ext.getCmp('btnPreview').disabled == false) {
        var list = document.getElementById('EPRList').all['ckbPrint'];
        var docEprNumList = "";

        if (list.length == undefined) {
            if (list.checked) {
                docEprNumList = docEprNumList + list.logDocID + "^" + list.EPRNum + "#"
            }
        }
        var listLength = list.length;
        for (var i = 0; i < listLength; i++) {
            if (list[i].checked) {
                docEprNumList = docEprNumList + list[i].logDocID + "^" + list[i].EPRNum + "#"
            }
        }
        //选中列表
        docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);

        if (docEprNumList == "") {
            alert('请先选中要操作的病历!');
            return;
        }
        var objUCPrint = document.getElementById('UCPrint');
        objUCPrint.EPRDocIDs = docEprNumList;
        objUCPrint.IsNewFramework = 'True';

        if (objUCPrint) {
            var strInstances = "";
            var ckbPrintList = document.getElementById('EPRList').all['ckbPrint'];
            var instanceList = document.getElementById('EPRList').all['valueTr'];
            if (ckbPrintList == null) { alert("历次列表无记录!"); return false; }
            if (ckbPrintList.length == undefined) {
                //表示只有一条记录
                if (ckbPrintList.checked) {
                    strInstances = instanceList.instanceid + ",";
                }
            }
            else {
                //add by zhuj on 2009-9-12
                var firstCkbPrintDocID = '-1';
                var ckbPrintListLength = ckbPrintList.length;
                for (var i = 0; i < ckbPrintListLength; i++) {
                    var curCkbPrint = ckbPrintList[i];
                    if (curCkbPrint.checked) {
                        if (firstCkbPrintDocID == '-1') {
                            firstCkbPrintDocID = curCkbPrint.logDocID;
                        }

                        else if (firstCkbPrintDocID != curCkbPrint.logDocID) {
                            alert('每次预览只能选择同一模板的数据!');
                            return false;
                        }
                    }
                    else {
                        continue;
                    }
                }



                var ckbPrintListLength = ckbPrintList.length;
                for (var i = 0; i < ckbPrintListLength; i++) {
                    var curCkbPrint = ckbPrintList[i];
                    if (curCkbPrint.checked) {
                        var curInstanceID = instanceList[i].instanceid;
                        if (curInstanceID) { strInstances += curInstanceID + ","; }
                    }
                    else {
                        continue;
                    }
                }

            }

            if (!(strInstances == "")) {
                var strResult = strInstances.substr(0, strInstances.length - 1);

                var result = objUCPrint.PreviewMultiple(_PatientID, _EpisodeID, strResult, _UserID, _PrtTemplateDocID);
                return result
            }
            else {
                alert("请选择需要预览的条目");
                return false
            }
        }

    }

} 

//预览
function exportRecord() {
    if (Ext.getCmp('btnExport').disabled == false) {
        var list = document.getElementById('EPRList').all['ckbPrint'];
        var docEprNumList = "";

        if (list.length == undefined) {
            if (list.checked) {
                docEprNumList = docEprNumList + list.logDocID + "^" + list.EPRNum + "#"
            }
        }
        var listLength = list.length;
        for (var i = 0; i < listLength; i++) {
            if (list[i].checked) {
                docEprNumList = docEprNumList + list[i].logDocID + "^" + list[i].EPRNum + "#"
            }
        }
        //选中列表
        docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);

        if (docEprNumList == "") {
            alert('请先选中要操作的病历!');
            return;
        }
        var objUCPrint = document.getElementById('UCPrint');
        objUCPrint.EPRDocIDs = docEprNumList;
        objUCPrint.IsNewFramework = 'True';

        if (objUCPrint) {
            var strInstances = "";
            var ckbPrintList = document.getElementById('EPRList').all['ckbPrint'];
            var instanceList = document.getElementById('EPRList').all['valueTr'];
            if (ckbPrintList == null) { alert("历次列表无记录!"); return false; }
            if (ckbPrintList.length == undefined) {
                //表示只有一条记录
                if (ckbPrintList.checked) {
                    strInstances = instanceList.instanceid + ",";
                }
            }
            else {
                //add by zhuj on 2009-9-12
                var firstCkbPrintDocID = '-1';
                var ckbPrintListLength = ckbPrintList.length;
                for (var i = 0; i < ckbPrintListLength; i++) {
                    var curCkbPrint = ckbPrintList[i];
                    if (curCkbPrint.checked) {
                        if (firstCkbPrintDocID == '-1') {
                            firstCkbPrintDocID = curCkbPrint.logDocID;
                        }

                        else if (firstCkbPrintDocID != curCkbPrint.logDocID) {
                            alert('每次预览只能选择同一模板的数据!');
                            return false;
                        }
                    }
                    else {
                        continue;
                    }
                }



                var ckbPrintListLength = ckbPrintList.length;
                for (var i = 0; i < ckbPrintListLength; i++) {
                    var curCkbPrint = ckbPrintList[i];
                    if (curCkbPrint.checked) {
                        var curInstanceID = instanceList[i].instanceid;
                        if (curInstanceID) { strInstances += curInstanceID + ","; }
                    }
                    else {
                        continue;
                    }
                }

            }

            if (!(strInstances == "")) {
                var strResult = strInstances.substr(0, strInstances.length - 1);

                var result = objUCPrint.ExportRecordMultiple(_PatientID, _EpisodeID, strResult, _UserID, _PrtTemplateDocID);
                return result
            }
            else {
                alert("请选择需要预览的条目");
                return false
            }
        }

    }

} 

//打印
function print()
{
    //edit by loo on 2010-7-28
    //修改内容：增加了一个判断“打印”按钮是否可按
    //修改原因：新增快捷键F9，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
    if(Ext.getCmp('btnPrint').disabled == false)
    {
	    var list = document.getElementById('EPRList').all['ckbPrint'];
	    var docEprNumList = "";
    	
	    if (list.length == undefined)
	    {
		    if (list.checked)
		    {
			    docEprNumList = docEprNumList + list.logDocID + "^" + list.EPRNum + "#"
		    }		
	    }
	    var listLength = list.length;
	    for (var i = 0; i < listLength; i++)
	    {
		    if (list[i].checked)
		    {
			    docEprNumList = docEprNumList + list[i].logDocID + "^" + list[i].EPRNum + "#"
		    }
	    }
	    //选中列表
	    docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);
    	
	    if (docEprNumList == "")
	    {
		    alert('请先选中要操作的病历!');	
		    return;
	    }
	    var objUCPrint =document.getElementById('UCPrint');
	    objUCPrint.EPRDocIDs = docEprNumList;
	    objUCPrint.IsNewFramework = 'True';
	    PrintClickHandler();
	    /*
	    var result = PrintClickHandler();
    	
	    if(!result)
	    {
		    return;	
	    }
	    */

    	
	    //printLog(docEprNumList);
	}
	
} 



//刷新
function refresh()
{		
	ajaxAction();
} 

//选择模板
function sltTemplate()
{		
	var selectNode = parent.parent.selectParentNode;
	parent.parent.templateSelect(selectNode, _EpisodeID);
}   

//增加北京CA数字签名参数 lingchen      
//userID, episodeID, printTemplateDocId, IDs, signValue, contentHash, 增加 docEprNumList，templateDocId
var args = new Array(8); 


//主任审核
function chiefCheck()
{		
	var list = document.getElementById('EPRList').all['ckbPrint'];
	
	var docEprNumList = "";
	var instanceList = document.getElementById('EPRList').all['valueTr'];
  var curInstanceID ="";
  
  if (list == null)
	{
		alert("历次列表无记录!"); 
		return;
	}
	if (list.length == undefined)
	{
		if (list.checked)
		{
			if(list.statusCode != 'commited' && list.statusCode != 'attendingChecked')
			{
				alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
				return;				
			}
			docEprNumList = docEprNumList + list.logDocID + "^" + list.EPRNum + "#";
      curInstanceID = instanceList.instanceid;
		}		
	}
	var listLength = list.length;
	for (var i = 0; i < listLength; i++)
	{
		if (list[i].checked)
		{
			if(list[i].statusCode != 'commited' && list[i].statusCode != 'attendingChecked')
			{
				alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
				return;				
			}
		}	
	}
	
	for (var i = 0; i < listLength; i++)
	{
		if (list[i].checked)
		{
			docEprNumList = docEprNumList + list[i].logDocID + "^" + list[i].EPRNum + "#";
      curInstanceID = instanceList[i].instanceid;
		}
	}
	
	//选中列表
	docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);
	
	if (docEprNumList == "")
	{
		alert('请先选中要操作的病历!');	
		return;
	}
	   
  Ext.Ajax.request({
        url: '../web.eprajax.logs.DigitalSignatureService.cls',
        timeout: parent.parent.timedOut,
        params: { isCAOn: "isCAOn" },
        success: function(response, opts) {
                var obj = response.responseText;
                if (obj == "Y") 
                {	    
                      // lingchen	
                      if (docEprNumList.split("#").length >1)
                      {
                     	  alert("每次只能审核一条记录!"); 
                     	  return;
	                    }		
                      //userID, episodeID, printTemplateDocId, IDs, signValue, contentHash, 
                      args[0]=_UserID;
                      args[1]=_EpisodeID;
                      args[2]=_PrtTemplateDocID;
                      args[3]=curInstanceID;  
                      args[6]=docEprNumList;
                      UsrLevel="Chief";   
                      // 弹出输入框 登录成功///
                      var result = window.showModalDialog("../csp/dhc.epr.ca.audit.csp", self, "dialogWidth:250px;dialogHeight:160px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
                }
                else
                      eprAudit("Chief", docEprNumList);
        },
        failure: function(response, opts) {
            var obj = "操作错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;
            alert(obj);
        }
  });
}

//主治审核
function attendingCheck()
{
	var list = document.getElementById('EPRList').all['ckbPrint'];

  var docEprNumList = "";
  var instanceList = document.getElementById('EPRList').all['valueTr'];
  var curInstanceID ="";
    
	if (list == null)
	{
		alert("历次列表无记录!"); 
		return;
	}
	if (list.length == undefined)
	{
		if (list.checked)
		{
			if(list.statusCode != 'commited')
			{
				alert('只能审核当前状态为"提交"的病历!');
				return;				
			}
			docEprNumList = docEprNumList + list.logDocID + "^" + list.EPRNum + "#";
      curInstanceID = instanceList.instanceid;
		}		
	}
	
	var listLength = list.length;
	for (var i = 0; i < listLength; i++)
	{
		if (list[i].checked)
		{
			if(list[i].statusCode != 'commited')
			{
				alert('只能审核当前状态为"提交"的病历!');
				return;
			}
		}	
	}
	
	for (var i = 0; i < listLength; i++)
	{
		if (list[i].checked)
		{
			docEprNumList = docEprNumList + list[i].logDocID + "^" + list[i].EPRNum + "#";
      curInstanceID = instanceList[i].instanceid;
		}
	}
	
	//选中列表
	docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);
	
	if (docEprNumList == "")
	{
		alert('请先选中要操作的病历!');	
		return;
	}	

  //userID, episodeID, printTemplateDocId, IDs, signValue, contentHash, 
	//eprAudit("Attending", docEprNumList);
  Ext.Ajax.request({
        url: '../web.eprajax.logs.DigitalSignatureService.cls',
        timeout: parent.parent.timedOut,
        params: { isCAOn: "isCAOn" },
        success: function(response, opts) {
                var obj = response.responseText;
                if (obj == "Y") 
                {
                    // lingchen		
                    if (docEprNumList.split("#").length >1)
                    {
                     	alert("每次只能审核一条记录!"); 
                      return;
                    }	
                    args[0]=_UserID;
                    args[1]=_EpisodeID;
                    args[2]=_PrtTemplateDocID;
                    args[3]=curInstanceID;  
                    args[6]=docEprNumList;
                    UsrLevel="Attending";   
                    // 弹出输入框 登录成功
                    var result = window.showModalDialog("../csp/dhc.epr.ca.audit.csp", self, "dialogWidth:250px;dialogHeight:160px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");        
                }
                else
                    eprAudit("Attending", docEprNumList);
        },
        failure: function(response, opts) {
            var obj = "操作错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;
            alert(obj);
        }
    });
}

//日志记录部分--------------------------------------
///add by zhuj on 2009-7-28
///打印
function printLog(docEprNumList)
{		
	Ext.Ajax.request({
		url: '../web.eprajax.logs.updateMultiple.cls',
		timeout : parent.parent.timedOut,
		params: { EpisodeID: _EpisodeID, EPRDocIDs: docEprNumList, action: 'print'},
		success: function(response, opts) {
			var obj = response.responseText;
			if (obj == "success")
			{
				refresh();
			}
			else if (obj == "sessionTimedOut")
			{
				alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
			}
			else
			{
				alert("写入日志错误!错误原因:" + obj);
			}
			
			
		},
		failure: function(response, opts) {				
			var obj = "写入日志错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;				
			alert(obj);
		}
	});
}	



function setPower()
{
	initPower();			//add by zhuj on 2009-12-9
	
	if(canView == "1")
	{ Ext.getCmp('btnPreview').enable()}
	else
	{ Ext.getCmp('btnPreview').disable()}
	
	if(canView == "1" && canPrint == "1")
	{ Ext.getCmp('btnPrint').enable()}
	else
	{ Ext.getCmp('btnPrint').disable()}
	
	/*
	if(canView == "1" && canCommit == "1")
	{ Ext.getCmp('btnCommit').enable()}
	else
	{ Ext.getCmp('btnCommit').disable()}
	*/
	
	if(canView == "1" && canSwitch == "1")
	{ Ext.getCmp('btnSlttemplate').enable()}
	else
	{ Ext.getCmp('btnSlttemplate').disable()}

	if(canView == "1" && canChiefCheck == "1")
	{ Ext.getCmp('btnChiefCheck').enable()}
	else
	{ Ext.getCmp('btnChiefCheck').disable()}

	if(canView == "1" && canAttendingCheck == "1")
	{ Ext.getCmp('btnAttendingCheck').enable()}
	else
	{ Ext.getCmp('btnAttendingCheck').disable()}

	if(canView == "1" && canExport == "1")
	{ Ext.getCmp('btnExport').enable()}
	else
	{ Ext.getCmp('btnExport').disable()}
}

