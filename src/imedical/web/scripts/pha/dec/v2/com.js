/*
 * @模块:     煎药流程-煎药室公共
 * @编写日期: 2019-08-11
 * @编写人:   hulihua
 */

/**
 * 读卡
 * @method readCardClick
 * @param _fn：回调函数
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
				//卡有效
				if($('#txtBarCode')) {
					$('#txtBarCode').val(myAry[5]);
				}
				_fn();
				break;
			case '-200':
				$.messager.alert('提示', '卡无效', 'info', function () {
					return;
				});
				break;
			case '-201':
				//现金
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
	// 煎药室医院窗体
    AddHospCom: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('提示', '程序错误,未传授权表名或代码', 'error');
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
                    '           <label id="_HospListLabel" style="color:red;">'+$g("医院")+'</label>' +
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
 *	煎药状态执行界面弹出执行开始日期、时间框
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
	var idText = "执行开始时间"
	
    var htmlStr = '<div class = "pha-row" style="margin-top:28px;text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+ $g("开始日期") +'</div>'     
            +           '<div class="pha-col" style="margin-left:0px">'
			+				'<input id = "startExeDate" class = "hisui-datebox" />'
			+			'</div>'
            + 	 '</div>'
			+	  '<div class = "pha-row" style="text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+ $g("开始时间") +'</div>'
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
        title:   $g("请选择" + idText),
        width: 300, 
        height: 200,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'确定',
            handler:function(){
				var startExeDate = $("#startExeDate").datebox('getValue')||"";
                if(startExeDate == ""){
                    $.messager.alert('提示', "请选择执行开始日期", 'error');
                    return
                }
				var startExeTime = $("#startExeTime").timespinner('getValue')||"";
                if(startExeTime == ""){
                    $.messager.alert('提示', "请选择执行开始时间", 'error');
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
            text:'关闭',
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
