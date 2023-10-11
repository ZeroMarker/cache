/**
 * ģ��:     ���������󹫹�����
 * ��д����: 2022-05-10
 * ��д��:   yangsj
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
	        	{text: '����ȡ��', 	 	id: 'roundFlag' , 	selected: true},
	        	{text: 'ȡ��������', 	id: 'originFlag' , 	selected: false},
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
		�·�Biz��ͷ������Ϊ��������
		pJson: ���
		method: ������
		callback: �ص�����
		synFlag: true/false(Ĭ��)  ͬ��/�첽
		noConfirm: true/false(Ĭ��)  ����ȷ����ʾ/��
		promptTitle: ����ʱ����ʾ
	*/
	BizConfirm : function(pJson, method, callback, synFlag, promptTitle){
		synFlag = synFlag || false;
		promptTitle = promptTitle || '';
		if(promptTitle == '') promptTitle = INRQ_COM.GetPromptTitle(method);
		PHA.Confirm('��ʾ', promptTitle, function () {
	        return INRQ_COM.Biz(pJson, method, callback, synFlag)
	    });
	},
	BizPrompt:function (pJson, method, callback, synFlag){
		PHA.BizPrompt({ title: '����' }, function (promptRet) {
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
	            return '��ȷ��ɾ����?';
	        case 'DeleteRefuse' :  
	            return '��ȷ��ɾ���ܾ���ϸ/������?';
	        case 'SaveInrq' :  
	            return '��ȷ�ϱ�����?';
	        case 'SaveInrq' :  
	            return '��ȷ�������?';
	        default :  
	            return '��ȷ��ִ�� '+method+' ��?';
	    }
	},
	/* ��ת���Ƶ����� */
	SkipLink : function(inrqId){
		if(!inrqId) return;
		com.Top.Set('inrqId', inrqId);
		PHA_COM.GotoMenu({
            title: '��������Ƶ�',
            url: 'pha.in.v3.req.create.csp'
        });
	},
	/* ��ѯ�����б� */
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
	/* ��ѯ������ϸ�б� */
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
	/* ��ѯ״̬�����б� */
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
                var ret = top.PHA_IN_REQ[key] || ''; // ��������Ҫ���
                if (clearFlag === true) {
                    delete top.PHA_IN_REQ[key];
                }
                return ret;
            }
            return '';
        }
    },
	
}
