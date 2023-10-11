/**
 * ģ��:     ������ת�ƹ������ݺͷ���
 * ��д����: 2022-05-10
 * ��д��:   yangsj
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
		if(promptTitle == '') promptTitle = INIT_COM.GetPromptTitle(method);
		PHA.Confirm('��ʾ', promptTitle, function () {
	        return INIT_COM.Biz(pJson, method, callback, synFlag)
	    });
	},
	BizPrompt:function (pJson, method, callback, synFlag){
		PHA.BizPrompt({ title: '����' }, function (promptRet) {
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
	/* ��ȡ���� */
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
	            return '��ȷ��ɾ����?';
	        case 'SaveInit' :  
	            return '��ȷ�ϱ�����?';
	        case 'CompInit' :  
	            return '��ȷ�������?';
	        case 'Audit' :  
	            return '��ȷ�����ͨ����?';
	        case 'AuditForIn' :  
	            return '��ȷ��ת�ƽ�����?';
	        case 'CancelAuditForIn' :  
	            return '��ȷ��ȡ��ת�ƽ�����?';
	         case 'MZJYAudit' :  
	            return '��ȷ��ִ���龫�����?';   
	        default :  
	            return '��ȷ��ִ�� '+method+' ��?';
	    }
	},
	/* ��ת���Ƶ����� */
	SkipLink : function(initId){
		if(!initId) return;
		//location.href='pha.in.v3.trans.create.csp?skipInitId=' + initId;
		PHA_COM.GotoMenu({
            title: '���ת���Ƶ�',
            url: 'pha.in.v3.trans.create.csp?skipInitId=' + initId
        });
	}
	,
	/* ת������Ϊ�ַ�����ʽ */
	GetDateStr : function(days){
		days = parseInt(days);
		if(days < 0) return 't' + days;
		else return 't+' + days;
	},
	
	/* ��ѯת�Ƶ��б� */
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
	/* ��ѯת�Ƶ���ϸ�б� */
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
	/* ��ѯ״̬�����б� */
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
	/* ��ȡת������id */
	GetInitId : function(domId){
		var gridSelect = $('#' + domId).datagrid('getSelected') || '';
	    if (gridSelect) return gridSelect.initId;
	    return '';
	},
	/* ��ȡת���ӱ�id */
	GetInitiId : function(domId){
		var gridSelect = $('#' + domId).datagrid('getSelected') || '';
	    if (gridSelect) return gridSelect.initiId;
	    return '';
	},
	/* ��ȡѡ���е�rowIndex */
	GetSelectRowIndex : function(domId){
		var gridSelect = $('#' + domId).datagrid('getSelected') || '';
	    if (gridSelect) return $('#' + domId).datagrid('getRowIndex', gridSelect);
	    return '';
	}
	
}
