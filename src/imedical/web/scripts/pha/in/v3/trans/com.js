/**
 * 模块:     定义库存转移公共数据和方法
 * 编写日期: 2022-05-10
 * 编写人:   yangsj
 * scripts/pha/in/v3/trans/com.js components
 */

var INIT_COM = {
	BUSICODE: 'TRANS',
	API: 'PHA.IN.TRANS.Api',
    ParamTrans : PHA_COM.ParamProp('DHCSTTRANSFER'),
	ParamCom: PHA_COM.ParamProp('DHCSTCOMMON'),
	SetKW : function(kwId,gridId){
		$('#' + kwId).keywords({
	        onClick:function(val){
		       INIT_COM.SetQty(kwId, gridId)
		    },
		    singleSelect: true,
	        items:[
	        	{text: '数量取整', 	 	id: 'roundFlag' , 	selected: true},
	        	{text: '取建议数量', 	id: 'originFlag' , 	selected: false},
	        ]
		});
	},
	
	SetQty : function(kwId, gridId){
		var kwObj = $('#' + kwId).keywords('getSelected');
		var kwId = kwObj[0].id;
		var rowsData = $('#' + gridId).datagrid('getRows');
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var qty = '';
			var sugQty = parseFloat(rowData.sugQty)
			if(kwId == 'roundFlag'){
				qty = parseInt(sugQty);
			}
			else if(kwId == 'originFlag'){
				qty = sugQty;
			}
			$('#' + gridId).datagrid('updateRow', {
	            index: i,
	            row: {
	                qty:qty
	            }
	        });
		}
	},
	AddSession : function(pJson){
		pJson['hospId']  = session['LOGON.HOSPID'];
		pJson['userId']  = session['LOGON.USERID'];
		pJson['ctlocId'] = session['LOGON.CTLOCID'];
		pJson['groupId'] = session['LOGON.GROUPID'];
		return pJson;
	},
	/* 
		下方Biz开头方法皆为操作方法
		pJson: 入参
		method: 方法名
		callback: 回调方法
		synFlag: true/false(默认)  同步/异步
		noConfirm: true/false(默认)  不弹确认提示/弹
		promptTitle: 弹框时的提示
	*/
	BizConfirm : function(pJson, method, callback, synFlag, promptTitle){
		synFlag = synFlag || false;
		promptTitle = promptTitle || '';
		if(promptTitle == '') promptTitle = INIT_COM.GetPromptTitle(method);
		PHA.Confirm('提示', promptTitle, function () {
	        return INIT_COM.Biz(pJson, method, callback, synFlag)
	    });
	},
	BizPrompt:function (pJson, method, callback, synFlag){
		PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
	        if (promptRet !== undefined) {
			    pJson['statusReason'] = promptRet;
			    return INIT_COM.Biz(pJson, method, callback, synFlag)
	        }
	    });
	},
	Biz: function(pJson, method, callback, synFlag){
		synFlag = synFlag || false;
		pJson = INIT_COM.AddSession(pJson);
		if(synFlag){
			var retData = PHA.CM(
		        {
		            pClassName : INIT_COM.API,  
		            pMethodName: method,
		            pJson	   : JSON.stringify(pJson),
		        },false)
		    return retData;
		}
		else {
			PHA.CM(
		        {
		            pClassName : INIT_COM.API,  
		            pMethodName: method,
		            pJson	   : JSON.stringify(pJson),
		        },
		        function (retData) {
			        if (PHA.Ret(retData)) {
						callback(retData.data);
						return true;
					}
					else return false;
		        }
		    )
		}
	},
	/* 获取数据 */
	Data : function(pJson, method){
		var retData = PHA.CM(
	        {
	            pClassName : INIT_COM.API,  
	            pMethodName: method,
	            pJson	   : JSON.stringify(pJson),
	        },false)
	    return retData;
	},
	
	GetPromptTitle:function(method){
		
	    switch (method) {
	        case 'Delete' :  
	            return '您确认删除吗?';
	        case 'SaveInit' :  
	            return '您确认保存吗?';
	        case 'CompInit' :  
	            return '您确认完成吗?';
	        case 'Audit' :  
	            return '您确认审核通过吗?';
	        case 'AuditForIn' :  
	            return '您确认转移接收吗?';
	        case 'CancelAuditForIn' :  
	            return '您确认取消转移接收吗?';
	         case 'MZJYAudit' :  
	            return '您确认执行麻精审核吗?';   
	        default :  
	            return '您确认执行 '+method+' 吗?';
	    }
	},
	/* 跳转到制单界面 */
	SkipLink : function(initId){
		if(!initId) return;
		//location.href='pha.in.v3.trans.create.csp?skipInitId=' + initId;
		PHA_COM.GotoMenu({
            title: '库存转移制单',
            url: 'pha.in.v3.trans.create.csp?skipInitId=' + initId
        });
	}
	,
	/* 转换日期为字符串格式 */
	GetDateStr : function(days){
		days = parseInt(days);
		if(days < 0) return 't' + days;
		else return 't+' + days;
	},
	
	/* 查询转移单列表 */
	QueryMain : function(domId, pJson){
		var $grid = $('#' + domId);
        var pJsonStr = JSON.stringify(pJson).replace(/_f/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: INIT_COM.API,
            pMethodName: 'QueryInit',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
	},
	/* 查询转移单明细列表 */
	QueryDetail : function(domId, pJson){
		var $grid = $('#' + domId);
        var pJsonStr = JSON.stringify(pJson).replace(/_f/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: INIT_COM.API,
            pMethodName: 'QueryDetail',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
	},
	/* 查询状态操作列表 */
	QueryInitStatus : function(domId, pJson){
		var $grid = $('#' + domId);
        var pJsonStr = JSON.stringify(pJson).replace(/_f/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: INIT_COM.API,
            pMethodName: 'QueryInitStatus',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
	},
	/* 获取转移主表id */
	GetInitId : function(domId){
		var gridSelect = $('#' + domId).datagrid('getSelected') || '';
	    if (gridSelect) return gridSelect.initId;
	    return '';
	},
	/* 获取转移子表id */
	GetInitiId : function(domId){
		var gridSelect = $('#' + domId).datagrid('getSelected') || '';
	    if (gridSelect) return gridSelect.initiId;
	    return '';
	},
	/* 获取选中行的rowIndex */
	GetSelectRowIndex : function(domId){
		var gridSelect = $('#' + domId).datagrid('getSelected') || '';
	    if (gridSelect) return $('#' + domId).datagrid('getRowIndex', gridSelect);
	    return '';
	}
	
}
