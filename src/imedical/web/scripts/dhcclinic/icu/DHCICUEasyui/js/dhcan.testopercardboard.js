/**
 * 测试手术安排卡片板块
 * @author yongyang 20180308
 */

$(document).ready(function() {
    var cardboard = operScheduleCardboard.init($('#oper_cardboard'), {
        filterForm: {
            items: [{
                    id: 'filter_appdept',
                    valueField: 'AppDeptID',
                    textField: 'AppDeptDesc',
                    value: 'All',
                    label: '',
                    desc: '申请科室',
                    type: 'combobox',
                    prompt: ''
                }, {
                    id: 'filter_operdept',
                    valueField: 'OperDeptID',
                    textField: 'OperDeptDesc',
                    value: 'All',
                    label: '',
                    desc: '手术室',
                    type: 'combobox',
                    prompt: ''
                },
                [{
                    id: 'filter_emergency',
                    valueField: 'SourceType',
                    textField: 'SourceTypeDesc',
                    value: 'E',
                    label: '急诊',
                    desc: '',
                    type: 'checkbox',
                    checked: true,
                    prompt: ''
                }, {
                    id: 'filter_elective',
                    valueField: 'SourceType',
                    textField: 'SourceTypeDesc',
                    value: 'B',
                    label: '择期',
                    desc: '',
                    type: 'checkbox',
                    checked: true,
                    prompt: ''
                }]
            ]
        },
        menu: {
            items: [{
                text: '安排手术间',
                iconCls: '',
                items: [{
                    text: '手术间01',
                    iconCls: '',
                    onClick: function(operCards) {
                        var p;
                        $.each(operCards, function(index, card) {
                            p = $('<div class="oper-card"></div>');
                            p.append('<div class="oper-card-header">第1台</div>');
                            p.append($(card._dom).html());
                            $('#oper_room').append(p);
                        });
                    }
                }, {
                    text: '手术间02',
                    iconCls: '',
                    onClick: function(operCards) {

                    }
                }]
            }]
        },
        operCard: {
            header: null,
            content: null,
            footer: null
        }
    });

    //cardboard.setOptions({});

    $.ajax({
        url: '../service/dhcanop/data/test.operschedule.json',
        method: 'GET',
        async: true,
        success: function(data) {
            cardboard.loadData(data);
        }
    });

    $('#oper_room').droppable({
        accept: '.oper-card',
        onDragEnter: function(e, source) {

        },
        onDragLeave: function(e, source) {

        },
        onDrop: function(e, source) {
            var p = $('<div class="oper-card"></div>');
            p.append('<div class="oper-card-header">第1台</div>');
            p.append($(source).html());
            $(this).append(p);
        }
    })
});