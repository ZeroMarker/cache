/**
 * ģ��:     ������ת�ƹ������
 * ��д����: 2022-05-10
 * ��д��:   zhaozhiduan
 * scripts/pha/op/v4/component.js 
 */

var OP_COMPOMENTS = {
    api: 'PHA.OP.COM.Api',
    url: PHA.$URL,
    Date: function (domId) {
        PHA.DateBox(domId, {});
        $('#' + domId).datebox('setValue', 't');
    },
    Element:{
        WinDesc:"curWinDesc",
        PyPerName:"curPyPerName",
        AutoPyErrInfo:"errInfo",
        LocDesc:"curLocDesc"
        
    },
    Columns : {
        PYMain : {
            Frozen : function (_options){
                var columns = [
                    { field: 'Select',          checkbox: true},
                    { field: 'Tphdrowid',       title: ('��ҩRowId'),     width: 80,      align: 'left',      hidden: true},
                    { field: 'TPhDispStat',     title: ('����״̬'),        width: 100,     align: 'left',
                        styler:function(value, row, index) {
                            return OP_COMPOMENTS.PrescStatusStyler(value, row, index);
                        }
                    },
                    { field: 'TPmiNo',          title: ('�ǼǺ�'),         width: 120,     align: 'left'},
                    { field: 'TPatName',        title: ('����'),          width: 80,      align: 'left'},
                    { field: 'TPrescNo',        title: ('������'),     width: 130,     align: 'left'}
                ]
                return [columns];
            },
            Normal : function (_options){
                var columns = [
                    { field: 'TPrtDate',        title: ('�շ�����'),        width: 150,     align: 'left'},
                    { field: 'TPrescMoney',     title: ('�������'),        width: 60,      align: 'left'},
                    { field: 'TPrescType',      title: ('�ѱ�'),          width: 60,      align: 'right'},
                    { field: 'TPrescTitle',     title: ('��������'),        width: 80,      align: 'right'},
                    { field: 'TWinDesc',        title: ('��ҩ����'),        width: 80,      align: 'left'},
                    { field: 'TMR',             title: ('���'),          width: 200,     align: 'left'},
                    { field: 'TPerAge',         title: ('����'),          width: 50,      align: 'left'},
                    { field: 'TPerSex',         title: ('�Ա�'),          width: 50,      align: 'left'},
                    { field: 'TPerLoc',         title: ('����'),          width: 200,     align: 'left',      hidden: true},
                    { field: 'TPrintFlag',      title: ('��ҩ'),          width: 50,      align: 'left',      hidden: true},
                    { field: 'TFyFlag',         title: ('��ҩ'),          width: 200,     align: 'left',      hidden: true},
                    { field: 'TPhawId',         title: ('�м��id'),       width: 200,     align: 'left',      hidden: true},
                    { field: 'TPatID',          title: ('����id'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TPatLevel',       title: ('���˼���'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TEncryptLevel',   title: ('�����ܼ�'),        width: 200,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel},
                    { field: 'TPatLevel',       title: ('���˼���'),        width: 120,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel}
                    
                ]
                return [columns];
            }
            
        },
        FYMain : {
            Frozen : function (_options){
                var columns = [
                    { field: 'Select',          checkbox: true},
                    { field: 'phdrow',          title: ('��ҩRowId'),     width: 80,      align: 'left',      hidden: true},
                    { field: 'TPhDispStat',     title: ('����״̬'),        width: 100,     align: 'left',
                        styler:function(value, row, index) {
                            return OP_COMPOMENTS.PrescStatusStyler(value, row, index);
                        }
                    },
                    { field: 'TPmiNo',          title: ('�ǼǺ�'),         width: 120,     align: 'left'},
                    { field: 'TPatName',        title: ('����'),          width: 80,      align: 'left'},
                    { field: 'TPrescNo',        title: ('������'),     width: 130,     align: 'left'}
                ]
                return [columns];
            },
            Normal : function (_options){
                var columns = [
                    { field: 'TPrtDate',        title: ('�շ�����'),        width: 150,     align: 'left'},
                    { field: 'TPrescMoney',     title: ('�������'),        width: 60,      align: 'left'},
                    { field: 'TMR',             title: ('���'),          width: 200,     align: 'left'},
                    { field: 'TPerAge',         title: ('����'),          width: 50,      align: 'left'},
                    { field: 'TPerSex',         title: ('�Ա�'),          width: 50,      align: 'left'},
                    { field: 'TDocSS',          title: ('���״̬'),        width: 80,      align: 'left'},
                    { field: 'TFyFlag',         title: ('��ҩ'),          width: 200,     align: 'left',      hidden: true},
                    { field: 'TFyDate',         title: ('��ҩ����'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TPrtInv',         title: ('��Ʊ��'),     width: 120,     align: 'left',      hidden: true},
                    { field: 'TEncryptLevel',   title: ('�����ܼ�'),        width: 200,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel},
                    { field: 'TPatLevel',       title: ('���˼���'),        width: 120,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel}
                    
                ]
                return [columns];
            }
        },
        DispMain : {
            Frozen : function (_options){
                var columns = [
                    { field: 'Select',          checkbox: true},
                    { field: 'Tphd',            title: ('��ҩRowId'),     width: 80,      align: 'left',      hidden: true},
                    { field: 'TPhDispStat',     title: ('����״̬'),        width: 100,     align: 'left',
                        styler:function(value, row, index) {
                            return OP_COMPOMENTS.PrescStatusStyler(value, row, index);
                        }
                    },
                    { field: 'TPmiNo',          title: ('�ǼǺ�'),         width: 120,     align: 'left'},
                    { field: 'TPatName',        title: ('����'),          width: 80,      align: 'left'},
                    { field: 'TPrescNo',        title: ('������'),     width: 130,     align: 'left'}
                ]
                return [columns];
            },
            Normal : function (_options){
                var columns = [
                    { field: 'TPrtDate',        title: ('�շ�����'),        width: 150,     align: 'left'},
                    { field: 'TPrescMoney',     title: ('�������'),        width: 60,      align: 'left'},
                    { field: 'TMR',             title: ('���'),          width: 200,     align: 'left'},
                    { field: 'TPatAge',         title: ('����'),          width: 50,      align: 'left'},
                    { field: 'TPatSex',         title: ('�Ա�'),          width: 50,      align: 'left'},
                    { field: 'TPrescType',      title: ('�ѱ�'),          width: 50,      align: 'left'},
                    { field: 'TWinDesc',        title: ('����'),          width: 50,      align: 'left'},
                    { field: 'TPatLoc',         title: ('����'),          width: 50,      align: 'left'},
                    { field: 'TDocSS',          title: ('���״̬'),        width: 80,      align: 'left'},
                    { field: 'TJS',             title: ('����'),          width: 80,      align: 'left',      hidden: PHAOP_COM.ColHidden.CYFlag},
                    { field: 'TOrdGroup',       title: ('Э������'),        width: 80,      align: 'left',      hidden: PHAOP_COM.ColHidden.CYFlag},
                    { field: 'TJYType',         title: ('��ҩ��ʽ'),        width: 120,     align: 'left',      hidden: PHAOP_COM.ColHidden.CYFlag},                    
                    { field: 'TPrintFlag',      title: ('��ҩ'),          width: 50,      align: 'left',      hidden: true},
                    { field: 'TFyFlag',         title: ('��ҩ'),          width: 50,      align: 'left',      hidden: true},
                    { field: 'TFyDate',         title: ('��ҩ����'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TPrtInv',         title: ('��Ʊ��'),     width: 120,     align: 'left',      hidden: true},
                    { field: 'TEncryptLevel',   title: ('�����ܼ�'),        width: 200,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel},
                    { field: 'TPatLevel',       title: ('���˼���'),        width: 120,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel},
                    { field: 'TPassCheck',      title: ('������ҩ'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TAdm',            title: ('����id'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TPatID',          title: ('����id'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TCallCode',       title: ('���ߵ绰'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TPatAdd',         title: ('���ߵ�ַ'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TPid',            title: ('���̺�'),     width: 120,     align: 'left',      hidden: true},                  
                    { field: 'TPrescTitle',     title: ('�����ѱ�'),        width: 120,     align: 'left',      hidden: true},  
                    { field: 'TCanOwe',         title: ('��Ƿҩ'),     width: 120,     align: 'left',      hidden: true}                   

                ]
                return [columns];
            }
        },
        Detail : {
            Frozen : function (_option){
                var columns = [
                
                    { field: 'TOrditm',         title: ('ҽ��id'),        width: 200,     align: 'left',      hidden: true},
                    { field: 'TPhDispItmStat',  title: ('��ϸ״̬'),        width: 80,      align: 'left',
                        styler:function(value, row, index) {
                            return OP_COMPOMENTS.ItmStatusStyler(value, row, index);
                        }
                    },
                    { field: 'drugIcon',        title: ('ͼ��'),          width: 80,      align: 'left',
                        formatter:function(value, row, index) {
                            return PHA_COM.Drug.Icon(value, row, index);
                        }
                    },
                    { field: 'TPhDesc',         title: ('ҩƷ����'),        width: 200,     align: 'left',
                        styler:function(value, row, index) {
                            return PHA_COM.Drug.Color(value, row, index);
                        }
                    },
                    { field: 'TPhQty',          title: ('ҽ������'),        width: 80,      align: 'left'},
                    { field: 'TRealQty',        title: ('ʵ������'),        width: 80,      align: 'left',
                        editor: PHA_GridEditor.NumberBox({
                            required: true,
                            checkOnBlur: true,
                            checkValue: function (val, checkRet) {
                                if (val == "") {
                                    checkRet.msg = "����Ϊ�գ�"
                                    return false;
                                }
                                var nQty = parseFloat(val);
                                if (isNaN(nQty)) {
                                    checkRet.msg = "���������֣�";
                                    return false;
                                }
                                if (nQty < 0) {
                                    checkRet.msg = "��������ڵ���0�����֣�";
                                    return false;
                                }
                                return true;
                            },
                            onBlur:function(val, rowData, rowIndex){
                                var realQty = parseFloat(val);;
                                var phQty = parseFloat(rowData.TPhQty);
                                var reg = /^[0-9]\d*$/;
                                if (!reg.test(realQty)) {
                                    PHAOP_COM._Alert("<span>"+rowData.TPhDesc +"</span>"+ $g("ʵ������ֻ��Ϊ����!"))
                                    return false;
                                }
                                if(phQty<realQty){
                                    PHAOP_COM._Alert("<span>"+rowData.TPhDesc +"</span>" + $g("ʵ�������費����ҽ������"))
                                    return false
                                }
                            }
                        })
                    },
                    { field: 'TPhUom',          title: ('��λ'),          width: 60,      align: 'left'}
                ]
                return [columns];
            },
            Normal : function(_option) {
                var columns = [
                    { field: 'TPhgg',           title: ('���'),          width: 120,     align: 'left'},
                    { field: 'TJL',             title: ('����'),          width: 100,     align: 'left'},
                    { field: 'TYF',             title: ('�÷�'),          width: 100,     align: 'left'},
                    { field: 'TPC',             title: ('Ƶ��'),          width: 80,      align: 'left'},
                    { field: 'TLC',             title: ('�Ƴ�'),          width: 80,      align: 'left'},
                    { field: 'TIncHW',          title: ('��λ'),          width: 60,      align: 'left'},
                    { field: 'TPhFact',         title: ('������ҵ'),        width: 220,     align: 'left'},
                    { field: 'TPhbz',           title: ('��ע'),          width: 120,     align: 'left'},
                    { field: 'TKCQty',          title: ('�������'),        width: 80,      align: 'left'},
                    { field: 'TYBType',         title: ('ҽ������'),        width: 80,      align: 'left'},
                    { field: 'TPrice',          title: ('����'),          width: 80,      align: 'left'},
                    { field: 'TMoney',          title: ('���'),          width: 60,      align: 'left'},
                    { field: 'TOrdStatus',      title: ('״̬'),          width: 80,      align: 'left'},
                    { field: 'TIncPC',          title: ('����'),          width: 80,      align: 'left',      hidden: true},
                    { field: 'TPrtNo',          title: ('��Ʊ��'),     width: 60,      align: 'left'},
                    { field: 'TSkinTest',       title: ('Ƥ��'),          width: 80,      align: 'left'},
                    { field: 'TPrescNo',        title: ('������'),         width: 80,      align: 'left'},
                    { field: 'TCInsuCode',      title: ('����ҽ����'),   width: 100,     align: 'left'},
                    { field: 'TCInsuDesc',      title: ('����ҽ������'),  width: 100,     align: 'left'},
                    { field: 'TInci',           title: 'TInci',         width: 100,     align: 'left',      hidden: true},
                    { field: 'TUnit',           title: 'TUnit',         width: 100,     align: 'left',      hidden: true},
                    { field: 'TOrditm',         title: 'TOrditm',       width: 100,     align: 'left',      hidden: true},
                    
                ]
                return [columns];
            }
        },
        FYCheckMain : {
            Normal : function (_options){
                var columns = [
                    { field: 'Select',          checkbox: true},
                    { field: 'TPrescNo',        title: ('������'),     width: 80,      align: 'left',      hidden: true},
                    { field: 'TOrditm',         title: ('ҽ��id'),        width: 100,     align: 'left',      hidden: true},
                    { field: 'TPrescStat',      title: ('����״̬'),        width: 120,     align: 'left',      hidden: true},
                    { field: 'TPhDesc',         title: ('ҩƷ����'),        width: 80,      align: 'left'},
                    { field: 'TPhQty',          title: ('����'),          width: 130,     align: 'left'},
                    { field: 'TPhUom',          title: ('��λ'),          width: 130,     align: 'left'},
                    { field: 'TJL',             title: ('����'),          width: 100,     align: 'left'},
                    { field: 'TYF',             title: ('�÷�'),          width: 100,     align: 'left'},
                    { field: 'TPC',             title: ('Ƶ��'),          width: 100,     align: 'left'},
                    { field: 'TLC',             title: ('�Ƴ�'),          width: 100,     align: 'left',      hidden: true},
                    { field: 'TBarCode',        title: ('����'),          width: 100,     align: 'left',      hidden: true},
                    { field: 'IecTypeStr',      title: ('�׻��ʶ'),        width: 100,     align: 'left',  
                        formatter:function(value, row, index) {
                            return OP_COMPOMENTS.IecTypeIconFormatter(value, row, index);
                        }
                    },
                    { field: 'TInci',           title: "TInci",             width: 100,     align: 'left',      hidden: true}
                ]
                return [columns];
            }
        }
    },
    WaitGrid :  function(gridId,_option) {
        var columns = [
            [
                { field: 'tSendVoice',      title: ('�к�'),          width: 80,      align: 'left',
                    styler:function(value, row, index) {
                        return OP_COMPOMENTS.WaitStatusStyler(value, row, index);
                    },
                    formatter:function(value, row, index) {
                        return OP_COMPOMENTS.WaitStatusFormatter(value, row, index);
                    }
                },
                { field: 'tbpatid',         title: ('�ǼǺ�'),          width: 120,     align: 'left'},
                { field: 'tbname',          title: ('����'),            width: 80,      align: 'left'},
                { field: 'queueNo',         title: ('�ŶӺ�'),          width: 80,      align: 'left',      hidden: true},
                { field: 'phwQuId',         title: ('�к�id'),          width: 80,      align: 'left',      hidden: true},
                { field: 'callFlag',        title: ('�к�״̬'),        width: 80,      align: 'left',      hidden: true},
                { field: 'TWarnLevel',      title: ('��ʾ����'),        width: 120,     align: 'left',      hidden: true},
                { field: 'TEncryptLevel',   title: ('�����ܼ�'),        width: 200,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel},
                { field: 'TPatLevel',       title: ('���˼���'),        width: 120,     align: 'left',      hidden: PHAOP_COM.ColHidden.PatLevel}
                    
            ]
        ];
        var dataGridOption = {  
            fit: true,      
            fitColumns:true,
            singleSelect: true,
            pagination: false,
            columns: columns,
            isCellEdit: false,
            allowEnd: false,
            isAutoShowPanel: true,
            toolbar : [],
            rowStyler: function(index,rowData){
                var warnLevel = rowData.TWarnLevel;
                var retCls = {}
                if ((warnLevel.indexOf($g("��")) >= 0) || (warnLevel.indexOf($g("��")) >= 0)) {
                    retCls = {
                         class: 'pha-op-grid-warn'
                    }
                }
                return retCls;
            }
        };
        var nOpts = $.extend({}, dataGridOption, _option); 
        OP_COMPOMENTS.ComomGrid(gridId, nOpts);
        var eventClassArr = [];
        eventClassArr.push('pha-grid-a icon icon-ring-blue');
        eventClassArr.push('pha-grid-a icon icon-skip-no');
        PHA.GridEvent(gridId, 'click', eventClassArr, function(rowIndex, rowData, className){
            var opType = "";
            if (className === 'pha-grid-a icon icon-ring-blue') {
                var patNo = rowData.tbpatid;
                var phwQuId = rowData.phwQuId;
                if (phwQuId != "") {
                    var state = "Call";
                    var retInfo = tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState", phwQuId, state);
                }
                PHAOP_COM.SendOPInfoToMachine({
                    faceCode:"103,107", 
                    patNo:patNo
                }) // �к�����  �к�����
                $("#"+gridId).datagrid('reload')
            }
            if (className === 'pha-grid-a icon icon-skip-no') {
                    var phwQuId = rowData.phwQuId;
                    if (phwQuId == "") {
                        PHAOP_COM._Alert("û�б����Ŷ�,�������!");
                        return;
                    }
                    var state = "Skip";
                    var retInfo = tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState", phwQuId, state);
                    $("#"+gridId).datagrid('reload')
            }
            
        })
    },
    FyWinGrid :  function(gridId,_option) {
        var columns = [
            [
                { field: 'Select',          checkbox: true},
                { field: 'phwWinDesc',      title: ('��ҩ����'),        width: 150,     align: 'left'},
                { field: 'phwWinStat',      title: ('��ҩ����״̬'),  width: 150,     align: 'left',
                    formatter:function(value, row, index) {
                            return OP_COMPOMENTS.FyStatusFormatter(value, row, index);
                        }
                },
                { field: 'phwid',           title: ('��ҩid'),        width: 80,      align: 'left',      hidden: true},
                { field: 'defWinIp',        title: ('����ip'),        width: 80,      align: 'left',      hidden: true}
            ]
        ];
        var dataGridOption = {  
            singleSelect: false,
            pagination: true,
            columns: columns,
            isCellEdit: false,
            onLoadSuccess: function (data) {
                $('.hisui-switchboxFyStatus').switchbox();
                PHAOP_COM.SetDefWin(gridId);
            }
        };
        var nOpts = $.extend({}, dataGridOption, _option); 
        OP_COMPOMENTS.ComomGrid(gridId, nOpts);
        
    },
    ComomGrid:function(gridId,_option){
        var gridOption = {
            gridSave: true,
            fit: true,
            fitColumns:true,
            rownumbers: true,
            shiftCheck: true,
            singleSelect: true,
            checkOnSelect: false, // ��������, Ӧ���������빴ѡ�ֿ�, ���ǹ�ѡ����Ҫ�ֳܷ���Ϣ
            selectOnCheck: false,
            exportXls: false,
            toolbar : [],
            rowStyler: function(index,row){
            },
            onBeforeLoad:function (){
                $("#"+gridId).datagrid("uncheckAll")
            }
        }
        var nOpts = $.extend({}, gridOption, _option); 
        
        PHA.Grid(gridId, nOpts);
    },
    PrescListGrid:function(gridId,_option){
        var gridOption = {
            rownumbers: true,
            fitColumns:false,
            shiftCheck: true,
            singleSelect: true,
            checkOnSelect: false, // ��������, Ӧ���������빴ѡ�ֿ�, ���ǹ�ѡ����Ҫ�ֳܷ���Ϣ
            selectOnCheck: false,
            rowStyler: function(index,rowData){
                //return OP_COMPOMENTS.GridDifRowStyler(index,rowData,"TPmiNo");
            }
        }
        var nOpts = $.extend({}, gridOption, _option); 
        OP_COMPOMENTS.ComomGrid(gridId, nOpts);
    },
    PrescDetailGrid:function(gridId,_option){
        var gridOption = {
            rownumbers: true,
            pagination:false,
            fitColumns:false,
            columns: this.Columns.Detail.Normal(),
            frozenColumns: this.Columns.Detail.Frozen(), 
            shiftCheck: true,
            singleSelect: true,
            checkOnSelect: false, // ��������, Ӧ���������빴ѡ�ֿ�, ���ǹ�ѡ����Ҫ�ֳܷ���Ϣ
            selectOnCheck: false,
            toolbar : "",
            rowStyler: function(index,rowData){
                return OP_COMPOMENTS.GridDifRowStyler(index,rowData,"TPrescNo");
            },
            onLoadSuccess: function(){ 
                PHA_COM.Drug.Tips(); 
            }
        }
        var nOpts = $.extend({}, gridOption, _option); 
        OP_COMPOMENTS.ComomGrid(gridId, nOpts);
    },
    // ����״̬ ()
    PrescStatusStyler : function(value, row, index){
        var statusCode = row.TPhDispStat || "";
        var styleCls = "";
         switch (statusCode) {
             case $g("����ҩ"):
                 styleCls = {class:'pha-op-grid-py'};
                 break;
             case $g("�ѷ�ҩ"):
                 styleCls = {class:'pha-op-grid-fy'};
                 break;
             case $g("�Ѵ�ӡ"):
                 styleCls = {class:'pha-op-grid-printed'};
                 break;
             default:
                 break;
         }
         return styleCls;
    },
    //������ϸ״̬
    ItmStatusStyler : function(value, row, index){
        var statusCode = row.TPhDispItmStat || ""
        var styleCls = "";
        if (statusCode == $g("��治��")) {
            styleCls = {class:'pha-op-grid-nostock'}
        } else if ((statusCode.indexOf($g("����")) > -1) || (statusCode.indexOf("ֹͣ") > -1)) {
            styleCls = {class:'pha-op-grid-ordstop'};
        } else if ((statusCode.indexOf($g("�˷�")) > -1)|| (statusCode.indexOf($g("δ�շ�")) > -1)) {
            styleCls = {class:'pha-op-grid-owefee'};
        }
        return styleCls
    },      
    // ����ҩ�б�״̬ ()
    WaitStatusStyler : function(value, row, index){
        var statusCode = row.callFlag || ""
        var styleCls = "";
         switch (statusCode) {
             case '0':
                 styleCls = {class:'pha-op-grid-call'}
                 break;
             case '3':
                 styleCls = {class:'pha-op-grid-skip'}
                 break;
             case '5':
                 styleCls = {class:'pha-op-grid-unqueue'}
                 break;
         }
         return styleCls;
    },
    GridDifRowStyler: function(index,rowData,field){
        if (index == 0) {
            DIF_ALT = {
                LastVal: '',
                Cnt: 0,
                Cls: {}
            };
        }
        
        var lastVal = DIF_ALT.LastVal;
        var fieldVal = rowData[field] || "";
        if ((lastVal !=fieldVal)){
            DIF_ALT.Cnt++;
             if (DIF_ALT.Cnt % 2 == 0) {
                DIF_ALT.Cls = {
                    class: 'pha-op-grid-dif'
                };
            } else {
                DIF_ALT.Cls = {};
            }
        
        }
        DIF_ALT.LastVal = fieldVal;
        return DIF_ALT.Cls;
    },
    WaitStatusFormatter: function(val, rowData, rowIndex){      
        var retArr = [];
        retArr.push('<span class="pha-grid-a icon icon-ring-blue" title="�к�">&nbsp;</span>');
        retArr.push('<span class="pha-grid-a icon icon-skip-no" title="����">&nbsp;</span>');     
        return retArr.join('');
    },
    FyStatusFormatter : function(value, rowData, index){
        var fwWindId = rowData.phwid;
        var editFlag = APP_PROP.UpdateWindStatus != "Y" || false
        if( value == "����"){
            return  (
                "<div class=\"hisui-switchboxFyStatus\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'"+$g("����")+"',offText:'"+$g("����")+"',checked:" +
                "true" +
                ",disabled:"+editFlag+",onSwitchChange:function(e, obj){PHAOP_COM.ChangeWinStatus("+fwWindId+",obj.value,obj)}\"></div>"
            )
        } else {
            return (
                "<div class=\"hisui-switchboxFyStatus\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'"+$g("����")+"',offText:'"+$g("����")+"',checked:" +
                "false" +
                ",disabled:"+editFlag+",onSwitchChange:function(e, obj){PHAOP_COM.ChangeWinStatus("+fwWindId+",obj.value,obj)}\"></div>"
            )
        }
        
    },
    IecTypeIconFormatter:function (value, rowData, index) {
        var iecTypeStr = value;
        var Inci = rowData.TInci;
        var htmlStr = "";
        var iecType = "";
        if (iecTypeStr.indexOf("1") > -1) { //����
            iecType = "1";
            //htmlStr = "<img title='" + $g("����") + "' src='../scripts/pha/in/v1/drugicon/02-����.svg' width='20px' height='20px' />";

            htmlStr = "<a href='#' onmouseover='PHAOP_COM.ShowIncEasyCon(this,\"" + Inci + '","' + iecType + "\")' onmouseout='PHAOP_COM.HideIncEasyCon()'><img title='" + $g("����") + "' src='../scripts/pha/in/v1/drugicon/02-����.svg' width='30' height='30' /></a>";
        }
        if (iecTypeStr.indexOf("2") > -1) { //����
            iecType = "2";
            htmlStr = htmlStr + "<a href='#' onmouseover='PHAOP_COM.ShowIncEasyCon(this,\"" + Inci + '","' + iecType + "\")' onmouseout='PHAOP_COM.HideIncEasyCon()'><img title='" + $g("����") + "' src='../scripts/pha/in/v1/drugicon/03-����.svg' width='30' height='30'/></a>";
        }
        if (iecTypeStr.indexOf("3") > -1) { //һƷ���
            iecType = "3";
            htmlStr = htmlStr + "<a href='#' onmouseover='PHAOP_COM.ShowIncEasyCon(this,\"" + Inci + '","' + iecType + "\")' onmouseout='PHAOP_COM.HideIncEasyCon()'><img title='" + $g("һƷ���") + "' src='../scripts/pha/in/v1/drugicon/01-���.svg' width='30' height='30'/></a>";
        }
        return htmlStr;
    },
    Window : {
        ComInfo:{
            winId:"WindowInfo",
            gridId:"gridFyWin",
            type:"",
            height:"",
            width:""
        },
        Open:function(_opt,_fn){
            var type = _opt.type;
            var winOpts = {};
            PHA_COM.Window.Proportion = 1;
            if((type == "PY")||(type == "FY")||(type == "Disp")){
                winOpts.title = "��ѡ��ҩ����";
                winOpts.width = 600;
                winOpts.height = PHA_COM.Window.Height() * 0.5;
                winOpts.top = (PHA_COM.Window.Height() - winOpts.height)/2;
                winOpts.left = (PHA_COM.Window.Width() - winOpts.width)/2 ;
                winOpts.opType = type;
                OP_COMPOMENTS.Window.InitWindowFyWin(winOpts,_fn);
                
                // ��ѯ����
                //GetOperateDetail(pJson);
            }else if(type == "Permission"){
                winOpts.title = "Ȩ����ʾ";
                winOpts.width = 600;
                winOpts.height = 105;
                winOpts.top = (PHA_COM.Window.Height() - winOpts.height)/2;;
                winOpts.left = (PHA_COM.Window.Width() - winOpts.width)/2 ;
                winOpts.opType = type;
                OP_COMPOMENTS.Window.InitWindowPermission(winOpts,_opt);
            }else if(type == "AutoPY"){
                winOpts.title = "�Զ���ҩ";
                winOpts.width = PHA_COM.Window.Width() * 0.65;
                winOpts.height = PHA_COM.Window.Height() * 0.8
                winOpts.top = (PHA_COM.Window.Height() - winOpts.height)/2;;
                winOpts.left = (PHA_COM.Window.Width() - winOpts.width)/2 ;
                winOpts.opType = type;
                OP_COMPOMENTS.Window.InitWindowAutoPrint(winOpts,_fn);
            }
            // �޸Ĵ��ڱ���
            $('#'+ this.ComInfo.winId ).window('setTitle', winOpts.title);
            $('#'+ this.ComInfo.winId ).window('open');
        },
        InitWindowFyWin:function(_opt,_callBack){
            var winWidth= _opt.width || PHA_COM.Window.Width() * 0.65;
            var winHeight = _opt.height || PHA_COM.Window.Height() * 0.5;
            var width = winWidth - 22;
            var height = winHeight - 58;  
            if(_opt.opType !== this.ComInfo.type){
                var $widow = $('#' + this.ComInfo.winId);
                if ($widow.length === 0){
                    var $widow = $('<div id="'+ this.ComInfo.winId +'"></div>').appendTo('body');
                }
                $widow.empty();
                $widow.append('<div  class = "pha-op-win-body" style="width:'+width+'px;height:'+height+'px;">'
                                +   '<div style="border:1px solid #cccccc;border-radius:4px;width:'+width+'px;height:'+height+'px;"  >'
                                +       '<div id="'+ this.ComInfo.gridId +'"></div>'
                                +   '<div>'
                                +'</div>'
                );
                this.ComInfo.type = _opt.opType;
            } else {
                return; 
            }           
            
            if (typeof _opt === "undefined"){
                var _opt = {};  
            }
            if(_opt.opType == "PY"){this.InitPYWindow()}
            if(_opt.opType == "FY"){this.InitFYWindow()}
            if(_opt.opType == "Disp"){this.InitDispWindow()}
            $widow.window({
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closable: false,
                closed: true,               
                modal: true,
                title: _opt.title || "����",
                width: winWidth, 
                height: winHeight,               
                top:_opt.top || 400,
                left:_opt.left || 300, 
                iconCls:'icon-w-paper',
                onOpen: function(){
                    var $grid = $("#"+OP_COMPOMENTS.Window.ComInfo.gridId);
                    $grid.datagrid('options').url = PHA.$URL;
                    $grid.datagrid('query',{
                        pClassName:'PHA.OP.COM.Store' ,
                        pMethodName:'jsQueryDispWinList',
                        pPlug:'datagrid',
                        ctloc: PHA_COM.Session.CTLOCID,
                        ChkRelFlag: ""
                    }); 
                },
                onClose: function(){                
                    if(_callBack){
                        _callBack();
                    }
                }
            }); 
        },
        InitPYWindow:function(){
            var htmlStr =  '<div>'
                            +'<table class = "pha-con-table" >'
                            +   '<tr>'
                            +       '<td class = "r-label">'
                            +           '<label for = "timeStep">'+$g("ʱ����")+'</label>'
                            +       '</td>'
                            +       '<td>'
                            +           '<input id = "timeStep" class = "validatebox-text" style="border-radius:2px;" value="30">'
                            +       '</td>'
                            +       '<td>'
                            +           $g("��")
                            +       '</td>'
                            +       '<td>'
                            +           '<a id="btnConfirm">'+"ȷ��"+'</a>'
                            +       '</td>'
                            +   '</tr>'
                            + '</table>'
                            +'</div>'
            var $toolbar = $(htmlStr).prependTo('#'+ this.ComInfo.winId);
            $('#btnConfirm').linkbutton({
                onClick: function(){
                    var ret = PHAOP_COM.PYWindowConfirm();
                    if(ret){
                        $('#'+ OP_COMPOMENTS.Window.ComInfo.winId ).window('close');
                    }
                }   
            });
            
            OP_COMPOMENTS.FyWinGrid(this.ComInfo.gridId,{
                toolbar: $toolbar,
            })
        },
        InitFYWindow:function(){
            var htmlStr = '<div>'
                            +'<table class = "pha-con-table" >'
                            +   '<tr>'
                            +       '<td class = "r-label">'
                            +           '<label for = "fyWinId">'+$g("��ҩ����")+'</label>'
                            +       '</td>'
                            +       '<td>'
                            +           '<input id = "fyWinId" class = "hisui-combobox" >'
                            +       '</td>'
                            +       '<td>'
                            +           '<a id="btnConfirm">'+"ȷ��"+'</a>'
                            +       '</td>'
                            +   '</tr>'
                            + '</table>'
                            +'</div>'
            var $toolbar = $(htmlStr).prependTo('#'+ this.ComInfo.winId);
            
            $('#btnConfirm').linkbutton({
                onClick: function(){
                    var ret = PHAOP_COM.FYWindowConfirm();
                    if(ret){
                        $('#'+ OP_COMPOMENTS.Window.ComInfo.winId ).window('close');
                    }
                }   
            });
            // ��ҩ����
            PHA.ComboBox('fyWinId',{
                editable:false, 
                url: PHAOP_STORE.PhlWin().url+"&locId="+PHAOP_COM.LogonData.LocId+"&useFlag=1"
            });
            OP_COMPOMENTS.FyWinGrid(this.ComInfo.gridId,{
                singleSelect: true,
                toolbar: $toolbar
                
                
            })
            $('#'+this.ComInfo.gridId).datagrid('hideColumn',"Select")
        },
        InitDispWindow:function(){
            var htmlStr = '<div >'
                            +'<table class = "pha-con-table" >'
                            +   '<tr>'
                            +       '<td class = "r-label">'
                            +           '<label for = "fyWinId">'+$g("��ҩ����")+'</label>'
                            +       '</td>'
                            +       '<td>'
                            +           '<input id = "fyWinId" class = "hisui-combobox ">'
                            +       '</td>'
                            +       '<td class = "r-label">'
                            +           '<label for = "pyPerId">'+$g("��ҩ��")+'</label>'
                            +       '</td>'
                            +       '<td>'
                            +           '<input id = "pyPerId" class = "hisui-combobox ">'
                            +       '</td>'
                            +       '<td>'
                            +           '<a id="btnConfirm">'+"ȷ��"+'</a>'
                            +       '</td>'
                            +   '</tr>'
                            + '</table>'
                            + '</div>'
            var $toolbar = $(htmlStr).prependTo('#'+ this.ComInfo.winId);
            
            $('#btnConfirm').linkbutton({
                onClick: function(){
                    var ret = PHAOP_COM.DispWindowConfirm();
                    if(ret){
                        $('#'+ OP_COMPOMENTS.Window.ComInfo.winId ).window('close');
                    }
                }   
            });
            // ��ҩ����
            PHA.ComboBox('fyWinId',{
                editable:false, 
                url: PHAOP_STORE.PhlWin().url+"&locId="+PHAOP_COM.LogonData.LocId+"&useFlag=1"
            });
            // ��ҩ�˴���
            PHA.ComboBox('pyPerId',{
                editable:false, 
                url: PHAOP_STORE.PhPerson().url+"&locId="+PHAOP_COM.LogonData.LocId+"&perFlag=2"
            });
            OP_COMPOMENTS.FyWinGrid(this.ComInfo.gridId,{
                singleSelect: true,
                toolbar: $toolbar
            })
            $('#'+this.ComInfo.gridId).datagrid('hideColumn',"Select")
        },
        InitWindowPermission:function(_opt,tipInfo){
            if(_opt.opType !== this.ComInfo.type){
                var $widow = $('#' + this.ComInfo.winId);
                if ($widow.length === 0){
                    var $widow = $('<div id="'+ this.ComInfo.winId +'"></div>').appendTo('body');
                }
                $widow.empty();
                var htmlStr = '<table class = "pha-con-table" >'
                            +   '<tr>'
                            +       '<td>'
                            +           '<div id="lb-permission"></div>'
                            +   '</td>'
                            +   '</tr>'
                            +   '<tr>'
                            +       '<td>'
                            +           '<div id="lb-permissioninfo"></div>'
                            +       '</td>'
                            +   '</tr>'
                            + '</table>'
                $widow.append(htmlStr);
                $("#lb-permission").text(tipInfo.msg)
                $("#lb-permissioninfo").text(tipInfo.info)
                this.ComInfo.type = _opt.opType;
            } else {
                $("#lb-permission").text(tipInfo.msg)
                $("#lb-permissioninfo").text(tipInfo.info)
                return; 
            }           
            
            if (typeof _opt === "undefined"){
                var _opt = {};  
            }
            $widow.window({
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closable: false,
                closed:true,                
                modal: true,
                title: _opt.title || "����",
                width: _opt.width || PHA_COM.Window.Width() * 0.65,             
                height: _opt.height || PHA_COM.Window.Height() * 0.5,               
                top:_opt.top || 400,
                left:_opt.left || 300,
                iconCls:'icon-w-paper', 
                onOpen: function(){
                },
                onClose: function(){                
                
                }
            }); 
        },
        InitWindowAutoPrint:function(_opt,_callBack){
            if(_opt.opType !== this.ComInfo.type){
                var $widow = $('#' + this.ComInfo.winId);
                if ($widow.length === 0){
                    var $widow = $('<div id="'+ this.ComInfo.winId +'"></div>').appendTo('body');
                }
                $widow.empty();
                var htmlStr = '<table width="100%" height="100%" >'
                            +   '<tr>'
                            +       '<td align="center">'
                            +           $g("�����Զ���ҩ��...")
                            +       '</td>'
                            +   '</tr>'
                            +   '<tr>'
                            +       '<td align="center">'
                            +           '<img src="../scripts/pha/com/v1/css/imgs/printing.gif" height="250px" width="250px">'
                            +       '</td>'
                            +   '</tr>'
                            +   '<tr>'
                            +       '<td>'
                            +           '<lable  id="'+OP_COMPOMENTS.Element.AutoPyErrInfo+'"></lable>'
                            +       '</td>'
                            +   '</tr>'
                            + '</table>'
                $widow.append(htmlStr);
                this.ComInfo.type = _opt.opType;
            } else {
                return; 
            }           
            
            if (typeof _opt === "undefined"){
                var _opt = {};  
            }
            $widow.window({
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closable: true, 
                closed:true,            
                modal: true,
                title: _opt.title || "����",
                width: _opt.width || PHA_COM.Window.Width() * 0.65, 
                height: _opt.height || PHA_COM.Window.Height() * 0.8,      
                left:_opt.left || 300,     
                top:_opt.top || 400, 
                iconCls:'icon-w-paper', 
                onOpen: function(){
                    if(_callBack){
                        _callBack();
                    }
                },
                onClose: function(){       
                    //clearInterval(PHAOP_COM.VAR.TIMER);
                    clearTimeout(PHAOP_COM.VAR.TIMER);
                }
            }); 
        }
    },
    Dialog : {
        ComInfo:{
            dialogId:"DialogInfo",
            gridId:"",
            type:"",
            height:"",
            width:""
        },
        Open:function (_opt, _fn){
            var type = _opt.type;
            var winOpts = {};
            if(type == "FYCheck"){
                this.ComInfo.gridId = "gridFYCheck"
                winOpts.title = "ҩƷ�˶�";
                winOpts.width = PHA_COM.Window.Width() * 0.65;
                winOpts.height = PHA_COM.Window.Height() * 0.8
                winOpts.top = (PHA_COM.Window.Height() - winOpts.height)/2 ;
                winOpts.left = (PHA_COM.Window.Width() - winOpts.width)/2 ;
                winOpts.opType = type;
                OP_COMPOMENTS.Dialog.InitDialogFYCheck(winOpts,_opt,_fn);
                            // �޸Ĵ��ڱ���
                $('#'+ this.ComInfo.dialogId ).dialog('setTitle', winOpts.title);
                $('#'+ this.ComInfo.dialogId ).dialog('open');

            }
        },
        /*
            ��ҩ�˶�dialog
            winOpt��������ز���
            _opt:   ������ز���,
            _fn:    �ص�����
        */
        InitDialogFYCheck:function (_winOpt, _opt, _fn){
            if(_winOpt.opType !== this.ComInfo.type){
                var $dialog = $('#' + this.ComInfo.dialogId);
                if ($dialog.length === 0){
                    var $dialog = $('<div id="'+ this.ComInfo.dialogId +'"></div>').appendTo('body');
                }
                $dialog.empty();
                
                $dialog.append('<div id="'+ this.ComInfo.gridId +'"></div>');
                this.ComInfo.type = _opt.opType;
            } else {
                return; 
            }           
            
            if (typeof _opt === "undefined"){
                var _opt = {};  
            }
            if( _winOpt.opType == "FYCheck"){OP_COMPOMENTS.Dialog.InitGridFYCheck(_opt, _fn)}
            $dialog.dialog({
                collapsible: false,
                minimizable: false,
                maximizable: false,
                closable: false,    
                closed:true,            
                modal: true,
                title: _opt.title || "����",
                width: _opt.width || PHA_COM.Window.Width() * 0.65, 
                height: _opt.height || PHA_COM.Window.Height() * 0.8,       
                left:_opt.left || 300, 
                iconCls:'icon-w-paper',     
                onOpen: function(){
                    var $grid = $("#"+OP_COMPOMENTS.Dialog.ComInfo.gridId);
                    PHA.CM({
                        pClassName: 'PHA.OP.PyDisp.Api',
                        pMethodName: 'GetDrugTotal',
                        pJson: JSON.stringify(_opt.pJson)
                    },function(retVal) {
                        $grid.datagrid('loadData', retVal.prescDetail);
                        var patInfo = retVal.patInfo;
                        $("#patInfo").text(patInfo.patName + " / " + patInfo.patSex + " / " + patInfo.patAge + " / " + patInfo.patNo)
                        $('#inciBarCode').val("");
                        $('#inciBarCode').focus();
                    },function(failRet){
                        PHAOP_COM._Alert(failRet);
                    })
                },
                onClose: function(){                
                    
                }
            }); 
        
        },
        /*
            ��ҩ�˶�dialog�Ĳ���
            winOpt��������ز���
            _opt:   ������ز���,
            _fn:    �ص�����
        */
        InitGridFYCheck:function(_opt, _fn){
                        var htmlStr = '<div class="" style="height:76px;">'
                            +'<table class = "pha-con-table" >'
                            +   '<tr>'
                            +       '<td>'
                            +           '<label for = "inciBarCode">'+$g("ҩƷ����")+'</label>'
                            +       '</td>'
                            +       '<td>'
                            +           '<input id = "inciBarCode" class = "hisui-validatebox ">'
                            +       '</td>'
                            +       '<td>'
                            +           '<a id="btnCheck">'+"�˶�"+'</a>'
                            +       '</td>'
                            +       '<td>'
                            +           '<a id="btnCheckAndFY">'+$g("�˶Բ���ҩ")+'</a>'
                            +       '</td>'
                            +       '<td>'
                            +           '<a id="btnClose">'+"�ر�"+'</a>'
                            +       '</td>'
                            +   '</tr>'
                            +   '<tr>'
                            +       '<td>'
                            +           $g("������Ϣ��")
                            +       '</td>'
                            +       '<td colspan = "4">'
                            +           '<div id = "patInfo" ></div>'
                            +       '</td>'
                            +   '</tr>'
                            /*+     '<tr>'
                            +       '<td>'
                            +           $g("������Ϣ��")
                            +       '</td>'
                            +       '<td colspan = "4">'
                            +           '<div id = "otherInfo"></div>'
                            +       '</td>'
                            +   '</tr>'*/
                            + '</table>'
                            + '</div>'
            var $toolbar = $(htmlStr).prependTo('#'+ OP_COMPOMENTS.Dialog.ComInfo.dialogId);
            $('#inciBarCode').on('keypress', function (event) {
                if (window.event.keyCode == "13") {
                    var barCode = $.trim($("#inciBarCode").val());
                    if (barCode != "") {
                        var $grid = $("#"+OP_COMPOMENTS.Dialog.ComInfo.gridId)
                        var rowsData = $grid.datagrid('getRows');
                        var len = rowsData.length;
                        for(var i = 0;i<len;i++){
                            var itemData =rowsData[i];
                            var gridBarCode= itemData.TBarCode;
                            if((gridBarCode != "") && (gridBarCode.indexOf(barCode + ",") > -1)) {
                                $grid.datagrid("checkRow",i)
                            } 
                        }
                    }
                    $('#inciBarCode').val("");
                }
                
                $('#inciBarCode').focus();
            });
            $('#btnCheck').linkbutton({
                onClick: function(){
                    var $grid = $("#"+OP_COMPOMENTS.Dialog.ComInfo.gridId)
                    var rowsData = $grid.datagrid('getData').rows;
                    var checkedRows = $grid.datagrid('getChecked');
                    if(rowsData.length != checkedRows.length ){
                        PHAOP_COM._Alert($g("��ҩƷδ�˶�!"));
                        return;
                    }
                    var lastPresc = ""
                    var pJson = {};
                    var prescArr = [];  
                    var len = checkedRows.length            
                    for (var i = 0;i < len;i++) {
                        var rowData = checkedRows[i]
                        var prescNo = rowData.TPrescNo;
                        if(prescNo == lastPresc){continue;}
                        lastPresc = prescNo;
                        prescArr.push({ 
                            prescNo : rowData.TPrescNo,
                        }); 
                    }
                    pJson.rows = prescArr;
                    pJson.userId = PHAOP_COM.LogonData.UserId;
                    pJson.flag = "Y";
                    var retVal = PHA.CM({
                        pClassName: 'PHA.OP.PyDisp.Api',
                        pMethodName: 'UpdCheckMainInfo',
                        pJson: JSON.stringify(pJson)
                    },false)
                    
                    var retCode = retVal.code; 
                    if (retCode < 0) {
                        PHAOP_COM._Alert(retVal.msg);
                        return;
                    } else {
                        $('#'+ OP_COMPOMENTS.Dialog.ComInfo.dialogId ).window('close');
                    }
                    
                }   
            });
            $('#btnCheckAndFY').linkbutton({
                onClick: function(){
                    var $grid = $("#"+OP_COMPOMENTS.Dialog.ComInfo.gridId)
                    var rowsData = $grid.datagrid('getData').rows;
                    var checkedRows = $grid.datagrid('getChecked');
                    if(rowsData.length != checkedRows.length ){
                        PHAOP_COM._Alert($g("��ҩƷδ�˶�!"));
                        return;
                    }
                    var lastPresc = ""
                    var pJson = {};
                    var prescArr = [];  
                    var len = checkedRows.length            
                    for (var i = 0;i < len;i++) {
                        var rowData = checkedRows[i]
                        var prescNo = rowData.TPrescNo;
                        if(prescNo == lastPresc){continue;}
                        lastPresc = prescNo;
                        prescArr.push({ 
                            prescNo : rowData.TPrescNo,
                        }); 
                    }
                    pJson.rows = prescArr;
                    pJson.userId = PHAOP_COM.LogonData.UserId;
                    pJson.flag = "Y";
                    var retVal = PHA.CM({
                        pClassName: 'PHA.OP.PyDisp.Api',
                        pMethodName: 'UpdCheckMainInfo',
                        pJson: JSON.stringify(pJson)
                    },false)
                    
                    var retCode = retVal.code; 
                    if (retCode < 0) {
                        PHAOP_COM._Alert(retVal.msg);
                        return;
                    }
                    $('#'+_opt.prescGrid).datagrid("checkAll")
                     _fn();
                    $('#'+ OP_COMPOMENTS.Dialog.ComInfo.dialogId ).window('close');
                }   
            });
            $('#btnClose').linkbutton({
                onClick: function(){
                        $('#'+ OP_COMPOMENTS.Dialog.ComInfo.dialogId ).window('close');
                }   
            });
            OP_COMPOMENTS.ComomGrid(OP_COMPOMENTS.Dialog.ComInfo.gridId,{
                columns: OP_COMPOMENTS.Columns.FYCheckMain.Normal(),
                toolbar: $toolbar,
                fitColumns:true,
                rownumbers: true,
                pageNumber:1,
                //view: groupview,
                groupField:"TPrescNo",
                groupFormatter: function (value, rows) {
                    var rowData = rows[0];
                    var viewDiv = '';
                    var prescDiv = '';
                    prescDiv += '<div id="grpViewPresc" class="pha-op-grid-grpviewpresc">';
                    prescDiv +=     '<div>' + rowData.TPrescNo + '</div>';
                    prescDiv += '</div>';
                    viewDiv+= '<div id="pha-op-grid-grpviewbase" class="pha-op-grid-grpviewbase">'  + prescDiv  + '</div>';
                    return viewDiv;
                },
                onLoadSuccess : function(data) {
                    if(data.total>0){
                        for(var i=0;i<data.total;i++){
                            var itemData =data.rows[i];
                            if(itemData.TSelect == "Yes"){
                                $(this).datagrid("checkRow",i)
                            } 
                        }
                    }
                }
            })
            $('#'+OP_COMPOMENTS.Dialog.ComInfo.gridId).datagrid('options').view = groupview;
        }
    
    }
        
}