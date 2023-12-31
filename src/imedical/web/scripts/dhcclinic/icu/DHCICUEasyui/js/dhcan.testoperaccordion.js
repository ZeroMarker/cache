$(document).ready(function() {
    var accordion = operScheduleAccordion.init($('#oper_accordion'), {
        groupKeyField: 'OperRoom',
        groupKeyDescField: 'RoomDesc',
        menu: {
            items: [{
                text: '转去其他手术间',
                iconCls: '',
                items: [{
                    text: '手术间01',
                    iconCls: '',
                    onClick: function(operCards) {

                    }
                }, {
                    text: '手术间02',
                    iconCls: '',
                    onClick: function(operCards) {

                    }
                }]
            }]
        }
        /*,
                item: {
                    operCard: {
                        header: null,
                        content: null,
                        footer: null
                    },
                    sorter: null
                }
                */
    });

    //cardboard.setOptions({});

    var banner = operScheduleBanner.init('#patinfo_banner', {});

    $.ajax({
        url: '../service/dhcanop/data/test.operaccordion.json',
        method: 'GET',
        async: true,
        success: function(data) {
            accordion.loadData(data);
            banner.loadData(data[0]);
        }
    });
});