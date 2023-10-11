var GV = {
	tableName: "Nur_IP_Quality.AppraiseEmrConfig"
}

$(function() {
    initUI()
})

function initUI(){
	
	if (IsManyHosps == 1) //��Ժ��ҵ��
    {
        //��ʼ��ҽԺ
        //var hospComp = GenUserHospComp();
        var sessionStr = [session['LOGON.USERID'], session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.HOSPID']]
        var hospComp = GenHospComp(GV.tableName, sessionStr.join("^"))
	    hospComp.jdata.options.onSelect = function(e,t){
			
			initWorkEmrConfig() 
			initAppEmrConfig()

        }
        hospComp.jdata.options.onLoadSuccess= function(data){
		    
	    }
    }

    initWorkEmrConfig() //��ʼ���ı�������ͳ����Ŀά��
    initAppEmrConfig()  //�������ʿ���Ŀ��ϵά��

}
function initWorkEmrConfig(){
    $('#inputEmrWorkConfigTable').datagrid({
        url: $URL,
        queryParams:{
             ClassName: 'Nur.Quality.Service.AppraiseEmrConfig',
             QueryName: 'getWorkEmrConfigList',
             inputEmrDesc: $('#inputWorkEmrDesc').val(),
             HospId: getHospId()
        },
        method: 'post',
        loadMsg: '����װ����......',
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        nowrap: false,
        columns: [[
            { field: 'emrWorkTitle', title: '��ͷ����', width: 80  },
            { field: 'emrWorkLink', title: '��������ģ��', width: 170 },
            { field: 'emrWorkSort', title: '����', width: 30},
            { field: 'emrArea', title: '���÷�Χ', width: 60},
            { field: 'emrUnArea', title: '�����÷�Χ', width: 60},
            { field: 'configID', title: 'ID', width: 200, hidden:true },
        ]],
        toolbar: [{
            iconCls: 'icon-add',
            text: '����',
            handler: function() {
                clickBtnEvent('workAdd')
            }
            }, {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function() {
	                clickBtnEvent('workDelete')
                }
            }
        ],
        onDblClickRow: function(rowIndex, rowData){
            clearAppEmrWin()
            setAppEmrWinValue(rowData['configID'], 'W', function(data){
                setAppEmrWin(data,'W')
                $('#commitBtn').unbind()
                $('#commitBtn').on('click',function(){
                    configHandler(rowData['configID'],"save","W",function(data){
                        if (data==0)
                        {
                            $.messager.popover({msg: '�޸ĳɹ�',type:'success',timeout: 1000});
                            $('#addAppEmrLinkWin').window('close')
                            $('#inputEmrWorkConfigTable').datagrid('reload')
                        }else{
                            $.messager.popover({msg: data.responseText,type:'error',timeout: 1000});
                        }
                    })
                })
                setWindow('W')
            })
        }
    })
}
function initAppEmrConfig(){
    //�б��ʼ��
    $('#inputEmrAppConfigTable').datagrid({
        url: $URL,
        queryParams:{
             ClassName: 'Nur.Quality.Service.AppraiseEmrConfig',
             QueryName: 'getAppEmrConfigList',
             inputEmrDesc: $('#inputAppEmrDesc').val(),
             HospId: getHospId()
        },
        method: 'post',
        loadMsg: '����װ����......',
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        nowrap: false,
        columns: [[
            { field: 'emrAppTitle', title: '�ʿ���Ŀ', width: 120  },
            { field: 'emrAppLink', title: '��������ģ��', width: 200 },
            { field: 'emrArea', title: '���÷�Χ', width: 60},
            { field: 'emrUnArea', title: '�����÷�Χ', width: 60},
            { field: 'configID', title: 'ID', width: 200, hidden:true },
        ]],
        toolbar: [{
            iconCls: 'icon-add',
            text: '����',
            handler: function() {
                clickBtnEvent('appAdd')
            }
            }, {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function() {
	            	clickBtnEvent('appDelete')
                }
            }
        ],
        onDblClickRow: function(rowIndex, rowData){
            clearAppEmrWin()
            setAppEmrWinValue(rowData['configID'], 'A', function(data){
                setAppEmrWin(data,'A')
                $('#commitBtn').unbind()
                $('#commitBtn').on('click',function(){
                    configHandler(rowData['configID'],"save","A",function(data){
                        if (data==0)
                        {
                            $.messager.popover({msg: '�޸ĳɹ�',type:'success',timeout: 1000});
                            $('#addAppEmrLinkWin').window('close')
                            $('#inputEmrAppConfigTable').datagrid('reload')
                        }else{
                            $.messager.popover({msg: '�޸�ʧ��',type:'error',timeout: 1000});
                        }
                    })
                })
                setWindow('A')
            })
        }
    })

    $('#searchWorkBtn').on('click',function(){
        searchBtnEvent('W')
    })

    $('#inputWorkEmrDesc').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            searchBtnEvent('W')
        }
    });

    $('#searchAppBtn').on('click',function(){
        searchBtnEvent('A')
    })

    $('#inputAppEmrDesc').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            searchBtnEvent('A')
        }
    });

     //����
     $('#inputWorkEmrSort').numberbox({
        min: 0,
    });

    $('#addAppEmrLinkWin').window({
        width: 410,
        height: 430,
        left: 730,
        top: 100,
        modal: false,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: '�༭'
    })
    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }
    /**����ģ������ */
    $('#inputAppEmrTitle').combobox({
        valueField: 'ID',
        textField: 'Desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.AppraiseEmrConfig&methodName=getAppraiseEmrTitle',
        filter: filter
    })

    /**���÷�Χ�벻���÷�Χ */
    $HUI.combobox('#inputAppEmrArea',{
        valueField: 'ID',
        textField: 'desc',
        multiple:true,
		rowStyle:'checkbox',
		selectOnNavigation:false,
		panelHeight:"300",
		editable:true,
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2=' + getHospId() + '&parameter3=' + GV.tableName,
        filter: filter
    })

    $HUI.combobox('#inputAppEmrUnArea',{
        valueField: 'ID',
        textField: 'desc',
        multiple:true,
		rowStyle:'checkbox',
		selectOnNavigation:false,
		panelHeight:"300",
		editable:true,
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2=' + getHospId() + '&parameter3=' + GV.tableName,
        filter: filter
    })

    runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","getEmrList",{parameter1:getHospId()},
        function(data){
            var data = eval(data)
            var html = ""
            for(var index in data){
                html += '<li value="' + data[index].ID + '">' + data[index].Desc + '</li>'
            }
            $('#jzul').html(html)

            $("#jzul>li").on('click', function(){
                //var id = $(this).attr("value");
                if ($(this).hasClass('active')) {
                    $(this).removeClass('active');
                } else {
                    $(this).addClass('active');
                }
            });
        
        
            $("#i-select").checkbox({
                onChecked: function () {
                    $("#jzul>li").each(function () {
                        if (!$(this).hasClass('active')) {
                            $(this).addClass('active');
                        }
                    });
                },
                onUnchecked: function () {
                    $("#jzul>li").each(function () {
                        if ($(this).hasClass('active')) {
                            $(this).removeClass('active');
                            $(this).removeClass('selected');
                        }
                    });
                }
            });

        }
    )

    /**ȷ�� �� ȡ����ť  commitBtn cancelBtn*/
    $('#cancelBtn').on('click',function(){
        $('#addAppEmrLinkWin').window('close')
    })
}
/** ����������ʿ���Ŀά���ı༭����*/
function clearAppEmrWin(){
    $('#inputAppEmrTitle').combobox('setValue',"")
    $('#inputWorkEmrTitle').val('')
    $('#inputWorkEmrSort').val('')
    $("#jzul>li").each(function () {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        }
    });
    $('#i-select').checkbox('setValue', false);
    $('#inputAppEmrArea').combobox('setValues',[]);
    $('#inputAppEmrUnArea').combobox('setValues',[]);
}
/** �����������ʿ���Ŀά���ı༭����*/
function setAppEmrWin(data,Type){
    if (Type=='A')
    {
        $('#inputAppEmrTitle').combobox('setValue',data['emrParID']);
    }else if(Type=='W')
    {
        $('#inputWorkEmrTitle').val(data['emrWorkTitle']);
        $('#inputWorkEmrSort').val(data['emrWorkSort']);
        validateAll()
    }
    $("#jzul>li").each(function () {
        if (data['emrLink'].indexOf($(this).attr('value')) > -1)
        {
            $(this).addClass('active');
        }
    });
    $('#inputAppEmrArea').combobox('setValues',eval(data['configArea']));
    $('#inputAppEmrUnArea').combobox('setValues',eval(data['configUnArea']));
}
/**��ȡ�������ʿ���Ŀά���ı༭���� ��ǰ��ѡ�е�ģ�� */
function getAppEmrListActive(){
    var allEmrCodeList = []
    $("#jzul>.active").each(function () {
        if (!$(this).hasClass('active')) {
            $(this).addClass('active');
        }
        allEmrCodeList.push($(this).attr("value"))
    });
    return allEmrCodeList
}
/**
 * ������̨��
 * @param {*} ID 
 * @param {*} Action 
 * @param {*} callback �ص�
 */
function configHandler(ID,Action,Type,callback)
{
    var config = {}
    if (Action != "delete")
    {
        config['ParID'] = $('#inputAppEmrTitle').combobox('getValue');
        config['WorkTitle'] = $('#inputWorkEmrTitle').val();
        config['WorkSort'] = $('#inputWorkEmrSort').val();
        config['LinkID'] = getAppEmrListActive();
        config['Type'] = Type;
        config['Area'] = $('#inputAppEmrArea').combobox('getValues');
        config['UnArea'] = $('#inputAppEmrUnArea').combobox('getValues');
    }
    /**�жϱ������Ƿ���д */
    if ((Type == "A")&&(config['ParID'] == ""))
    {
        $.messager.popover({msg: '�ʿ���ĿΪ��',type:'error',timeout: 1000});
        return
    }
    if ((Type == "W")&&((config['WorkTitle'] == "")||(config['WorkSort'] == "")))
    {
        $.messager.popover({msg: '��ͷ���� �� ���� Ϊ��',type:'error',timeout: 1000});
        return
    }
    if ((config['LinkID'])&&(config['LinkID'].length == 0))
    {
        $.messager.popover({msg: '����ģ��Ϊ��',type:'error',timeout: 1000});
        return
    }
    runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","configHandler",{
        parameter1: JSON.stringify(config),
        parameter2: ID,
        parameter3: Action,
        parameter4: Type,
        parameter5: getHospId()
    },function(data){
        callback(data)
    })
}
/**��ȡ�������ʿ���Ŀά���ı༭���� ��ֵ */
function setAppEmrWinValue(configID,Type,callback){
    runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","getEmrConfigByID",{
        parameter1: configID,
        parameter2: Type
    },function(data){
        callback(eval(data))
    })
}

function clickBtnEvent(id){
    switch (id) {
        case 'appAdd':
            addBtnEvent('A')
            break;
        case 'appDelete':
            deleteBtnEvent('A')
            break;
        case 'workAdd':
            addBtnEvent('W')
            break;
        case 'workDelete':
            deleteBtnEvent('W')
            break;
      }
}

function addBtnEvent(type){
    var tableID= (type=="A" ? 'inputEmrAppConfigTable':'inputEmrWorkConfigTable' )
    clearAppEmrWin()
    $('#commitBtn').unbind()
    if (type == "W") initEmrWorkSort()
    $('#commitBtn').on('click',function(){
        configHandler("","save",type,function(data){
            if (data==0)
            {
                $.messager.popover({msg: '��ӳɹ�',type:'success',timeout: 1000});
                $('#addAppEmrLinkWin').window('close')
                $('#' + tableID).datagrid('reload')
            }else{
                //$.messager.popover({msg: data.responseText,type:'error',timeout: 2000});
                $.messager.alert('������ʾ', data.responseText,'error');
            }
        })
    })
    setWindow(type)
}


function deleteBtnEvent(type){
    var tableID= (type=="A" ? 'inputEmrAppConfigTable':'inputEmrWorkConfigTable' )
    var emrAppConfigSelected = $('#' + tableID ).datagrid('getSelected')
    if (emrAppConfigSelected != null)
    {
        delConfirm(function(){
            var configID = emrAppConfigSelected['configID']
            configHandler(configID,"delete",type,function(data){
                if (data==0)
                {
                    $.messager.popover({msg: 'ɾ���ɹ�',type:'success',timeout: 1000});
                    $('#' + tableID).datagrid('reload')
                }else{
                    $.messager.popover({msg: 'ɾ��ʧ��',type:'error',timeout: 1000});
                }
            })
        })

    }else{
        $.messager.popover({msg: '��ѡ��һ����¼',type:'error',timeout: 1000});
    }
}

function setWindow(type)
{
    if (type=='A')
    {
        $('#inputAppEmrTitleTr').removeAttr("hidden")
        $('#inputWorkEmrTitleTr').attr("hidden","true")
        $('#addAppEmrLinkWin').window('resize',{
            left: 730,
            top: 100
        })
    }else if(type=='W')
    {
        $('#inputWorkEmrTitleTr').removeAttr("hidden")
        $('#inputAppEmrTitleTr').attr("hidden","true")
        $('#addAppEmrLinkWin').window('resize',{
            left: 140,
            top: 100
        })
    }
    $('#addAppEmrLinkWin').window('open')
}


function searchBtnEvent(Type)
{
    if (Type=='W')
    {
        var queryParams = $('#inputEmrWorkConfigTable').datagrid('options').queryParams
        queryParams.inputEmrDesc = $('#inputWorkEmrDesc').val()
        $('#inputEmrWorkConfigTable').datagrid('options').queryParams = queryParams;
        $('#inputEmrWorkConfigTable').datagrid('load')

    }else if(Type=='A')
    {
        var queryParams = $('#inputEmrAppConfigTable').datagrid('options').queryParams
        queryParams.inputEmrDesc = $('#inputAppEmrDesc').val()
        $('#inputEmrAppConfigTable').datagrid('options').queryParams = queryParams;
        $('#inputEmrAppConfigTable').datagrid('load')

    }
}

function initEmrWorkSort()
{
    var rows = $('#inputEmrWorkConfigTable').datagrid('getRows')
	var lastRow = 0
	if (rows.length != 0)
	{
		lastRow = rows[rows.length - 1]['emrWorkSort']
	}
    $('#inputWorkEmrSort').val(parseInt(lastRow) + 1)
    validateAll()  
    
}


function validateAll(){
	$('#inputWorkEmrSort').validatebox("validate")
	$('#inputWorkEmrTitle').validatebox("validate")
}

function getHospId()
{
	return (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
}