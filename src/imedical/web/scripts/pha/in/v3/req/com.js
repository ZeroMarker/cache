/**
 * 模块:     定义库存请求公共方法
 * 编写日期: 2022-05-10
 * 编写人:   yangsj
 * scripts/pha/in/v3/req/com.js
 */
 
var INRQ_COM = {
	API : 'PHA.IN.REQ.Api',
	SetKW : function(kwId,gridId){
		$('#' + kwId).keywords({
	        onClick:function(val){
		       INRQ_COM.SetQty(kwId, gridId)
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
	SetDisabled: function(btnArr, combArr){
		var btnArr = btnArr || [];
		var combArr = combArr || [];
		var btnLen = BTNARR.length
		for (i=0;i<btnLen;i++){
			btnId = BTNARR[i]
			if(btnArr.indexOf(btnId) >= 0) $('#' + btnId).linkbutton('disable');
			else $('#' + btnId).linkbutton('enable');
		}
		var combLen = COMBARR.length
		for (i=0;i<combLen;i++){
			combId = COMBARR[i]
			if(combArr.indexOf(combId) >= 0) $('#' + combId).combobox('disable')
			else $('#' + combId).combobox('enable')
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
		if(promptTitle == '') promptTitle = INRQ_COM.GetPromptTitle(method);
		PHA.Confirm('提示', promptTitle, function () {
	        return INRQ_COM.Biz(pJson, method, callback, synFlag)
	    });
	},
	BizPrompt:function (pJson, method, callback, synFlag){
		PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
	        if (promptRet !== undefined) {
			    pJson['statusReason'] = promptRet;
			    return INRQ_COM.Biz(pJson, method, callback, synFlag)
	        }
	    });
	},
	
	Biz: function(pJson, method, callback, synFlag){
		synFlag = synFlag || false;
		pJson = INRQ_COM.AddSession(pJson)
		if(synFlag){
			var retData = PHA.CM(
		        {
		            pClassName : INRQ_COM.API,  
		            pMethodName: method,
		            pJson	   : JSON.stringify(pJson),
		        },false)
		    return retData;
		}
		else {
			PHA.CM(
		        {
		            pClassName : INRQ_COM.API,  
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
	Data: function(pJson, method){
		pJson = INRQ_COM.AddSession(pJson)
		var retData = PHA.CM(
	        {
	            pClassName : INRQ_COM.API,  
	            pMethodName: method,
	            pJson	   : JSON.stringify(pJson),
	        },false)
	    return retData;
	},
	GetPromptTitle:function(method){
		
	    switch (method) {
	        case 'Delete' :  
	            return '您确认删除吗?';
	        case 'DeleteRefuse' :  
	            return '您确认删除拒绝明细/请求单吗?';
	        case 'SaveInrq' :  
	            return '您确认保存吗?';
	        case 'SaveInrq' :  
	            return '您确认完成吗?';
	        default :  
	            return '您确认执行 '+method+' 吗?';
	    }
	},
	/* 跳转到制单界面 */
	SkipLink : function(inrqId){
		if(!inrqId) return;
		com.Top.Set('inrqId', inrqId);
		PHA_COM.GotoMenu({
            title: '库存请求制单',
            url: 'pha.in.v3.req.create.csp'
        });
	},
	/* 查询请求单列表 */
	QueryMain : function(domId, pJson){
		var $grid = $('#' + domId);
        var pJsonStr = JSON.stringify(pJson).replace(/_f|_req/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: INRQ_COM.API,
            pMethodName: 'QueryInrq',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
	},
	/* 查询请求单明细列表 */
	QueryDetail : function(domId, pJson){
		var $grid = $('#' + domId);
        var pJsonStr = JSON.stringify(pJson).replace(/_f/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: INRQ_COM.API,
            pMethodName: 'QueryDetail',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
	},
	/* 查询状态操作列表 */
	QueryInrqStatus : function(domId, pJson){
		var $grid = $('#' + domId);
        var pJsonStr = JSON.stringify(pJson).replace(/_f/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: INRQ_COM.API,
            pMethodName: 'QueryInrqStatus',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
	},
	Top: {
        Const: ['PHA_IN_REQ_ROWID'],
        Set: function (key, value) {
            if (!top.PHA_IN_REQ) {
                top.PHA_IN_REQ = {};
            }
            top.PHA_IN_REQ[key] = value;
        },
        Get: function (key, clearFlag) {
            if (top.PHA_IN_REQ) {
                var ret = top.PHA_IN_REQ[key] || ''; // 对象则需要深拷贝
                if (clearFlag === true) {
                    delete top.PHA_IN_REQ[key];
                }
                return ret;
            }
            return '';
        }
    },
	
}
