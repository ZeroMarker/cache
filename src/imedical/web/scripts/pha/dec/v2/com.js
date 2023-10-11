/*
 * @ģ��:     ��ҩ����-��ҩ�ҹ���
 * @��д����: 2019-08-11
 * @��д��:   hulihua
 */

/**
 * ����
 * @method readCardClick
 * @param _fn���ص�����
 */
function readCardClick(_fn) {
	try {
		var cardType = $('#cmbCardType').combobox('getValue');
		var cardTypeDR = cardType.split('^')[0];
		var myRtn = '';
		if (cardTypeDR == '') {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split('^');
		var rtn = myAry[0];
		switch (rtn) {
			case '0':
				//����Ч
				if($('#txtBarCode')) {
					$('#txtBarCode').val(myAry[5]);
				}
				_fn();
				break;
			case '-200':
				$.messager.alert('��ʾ', '����Ч', 'info', function () {
					return;
				});
				break;
			case '-201':
				//�ֽ�
				if($('#txtBarCode')) {
					$('#txtBarCode').val(myAry[5]);
				}
				_fn();
				break;
			default:
		}
	} catch (e) {
		
	}
}


var DEC ={
	// ��ҩ��ҽԺ����
    AddHospCom: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('��ʾ', '�������,δ����Ȩ���������', 'error');
            return;
        }
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            $($('body>.hisui-layout')[0]).layout('add', {
                region: 'north',
                border: false,
                height: 40,
                split: false,
                bodyCls: 'pha-ly-hosp',
                content:
                    '<div style="padding-left:10px;">' +
                    '   <div class="pha-row">' +
                    '       <div class="pha-col">' +
                    '           <label id="_HospListLabel" style="color:red;">'+$g("ҽԺ")+'</label>' +
                    '       </div>' +
                    '   	<div class="pha-col">' +
                    '       	<input id="_HospList" class="textbox"/>' +
                    '   	</div>' +
                    '	</div>' +
                    '</div>'
            });
            var genHospObj = GenHospComp(tableName);
            return genHospObj;
        } else {
            return '';
        }
    }	
}

/**
 *	��ҩ״ִ̬�н��浯��ִ�п�ʼ���ڡ�ʱ���
 *	MaYuqiang 20230322
*/
function ShowExeDateTimeWin(winId, _fn){
    var $widow = $('#' + winId);
    if ($widow.length === 0){
        var $widow = $('<div id="'+ winId +'"></div>').appendTo('body');
        $widow.empty();
    }else{
        $('#'+ winId ).dialog('open');
        return
    }
    
    var marLeft = 10;
	var idText = "ִ�п�ʼʱ��"
	
    var htmlStr = '<div class = "pha-row" style="margin-top:28px;text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+ $g("��ʼ����") +'</div>'     
            +           '<div class="pha-col" style="margin-left:0px">'
			+				'<input id = "startExeDate" class = "hisui-datebox" />'
			+			'</div>'
            + 	 '</div>'
			+	  '<div class = "pha-row" style="text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+ $g("��ʼʱ��") +'</div>'
			+			'<div class="pha-col" style="margin-left:0px">'
			+				'<input id = "startExeTime" class = "hisui-timespinner" />'
			+			'</div>'
            + 	 '</div>'

    var $toolbar = $(htmlStr).prependTo('#'+ winId);
    
    PHA_COM.Window.Proportion = 1;
    $widow.dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        closed: true,               
        modal: true,
        title:   $g("��ѡ��" + idText),
        width: 300, 
        height: 200,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'ȷ��',
            handler:function(){
				var startExeDate = $("#startExeDate").datebox('getValue')||"";
                if(startExeDate == ""){
                    $.messager.alert('��ʾ', "��ѡ��ִ�п�ʼ����", 'error');
                    return
                }
				var startExeTime = $("#startExeTime").timespinner('getValue')||"";
                if(startExeTime == ""){
                    $.messager.alert('��ʾ', "��ѡ��ִ�п�ʼʱ��", 'error');
                    return
                }
                var retJson = {
					startExeDate: startExeDate,
					startExeTime: startExeTime
				}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'�ر�',
            handler:function(){$('#'+ winId ).dialog('close');}
        }],
        onOpen: function(){
			PHA.DateBox("startExeDate",{})
			//$HUI.validatebox("startExeDate",{});
			$HUI.timespinner("#startExeTime", {
				showSeconds: true
			});
			$("#startExeDate").datebox("setValue", 't');
            var curDateTime = new Date();
            var hours = curDateTime.getHours();
	 	    var minutes = curDateTime.getMinutes();
	 	    var seconds = curDateTime.getSeconds();
            var curTime = hours +":"+ minutes +":"+ seconds
			$("#startExeTime").timespinner('setValue', curTime);
			
        }
    });
    $('#'+ winId ).dialog('open');
}
