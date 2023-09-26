/// DHC_AN_AnaestItem
Class User.DHCANAnaestItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANI_RowId, SqlTableName = DHC_AN_AnaestItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ANIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_OPArrange Parent Reference
Relationship ANIParref As User.DHCANOPArrange [ Cardinality = parent, Inverse = ChildDHCANAnaestItem, Required, SqlFieldName = ANI_Parref ];

//Property ANIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"ANI",0))}, SqlColumnNumber = 2, SqlFieldName = ANI_ChildSub ];

//  For P8

/// ANI_ChildSub
Property ANIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"ANI",0))}, SqlColumnNumber = 2, SqlFieldName = ANI_ChildSub ];

/// ANI_PostAnaMark
Property ANIPostAnaMark As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = ANI_PostAnaMark ];

/// ANI_IntrathecalMark
Property ANIIntrathecalMark As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ANI_IntrathecalMark ];

/// ANI_IntrathPuncSuccess
Property ANIIntrathPuncSuccess As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANI_IntrathPuncSuccess ];

/// ANI_IntrathCathSuccess
Property ANIIntrathCathSuccess As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ANI_IntrathCathSuccess ];

/// ANI_NerveBlockMark
Property ANINerveBlockMark As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ANI_NerveBlockMark ];

/// ANI_NerveBlockPuncSucc
Property ANINerveBlockPuncSucc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ANI_NerveBlockPuncSucc ];

/// ANI_GeneralMark
Property ANIGeneralMark As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ANI_GeneralMark ];

/// ANI_GeneralInduceSucc
Property ANIGeneralInduceSucc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ANI_GeneralInduceSucc ];

/// ANI_IntubationMark
Property ANIIntubationMark As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ANI_IntubationMark ];

/// ANI_Intrathecal
Property ANIIntrathecal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ANI_Intrathecal ];

/// ANI_IntrathType
Property ANIIntrathType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ANI_IntrathType ];

/// ANI_IntrathEffect
Property ANIIntrathEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ANI_IntrathEffect ];

/// ANI_IntrathPos
Property ANIIntrathPos As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ANI_IntrathPos ];

/// ANI_IntrathPuncture
Property ANIIntrathPuncture As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ANI_IntrathPuncture ];

/// ANI_IntrathPuncSite
Property ANIIntrathPuncSite As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ANI_IntrathPuncSite ];

/// ANI_IntrathPuncApproach
Property ANIIntrathPuncApproach As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ANI_IntrathPuncApproach ];

/// ANI_IntrathPuncEffect
Property ANIIntrathPuncEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = ANI_IntrathPuncEffect ];

/// ANI_IntrathPuncPos
Property ANIIntrathPuncPos As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = ANI_IntrathPuncPos ];

/// ANI_IntrathPuncResist
Property ANIIntrathPuncResist As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ANI_IntrathPuncResist ];

/// ANI_IntrathPuncNegComp
Property ANIIntrathPuncNegComp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = ANI_IntrathPuncNegComp ];

/// ANI_IntrathPuncDiffFeel
Property ANIIntrathPuncDiffFeel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = ANI_IntrathPuncDiffFeel ];

/// ANI_IntrathPuncBleedAmt
Property ANIIntrathPuncBleedAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = ANI_IntrathPuncBleedAmt ];

/// ANI_IntrathPuncSpec
Property ANIIntrathPuncSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ANI_IntrathPuncSpec ];

/// ANI_IntrathPuncBevelDirect
Property ANIIntrathPuncBevelDirect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = ANI_IntrathPuncBevelDirect ];

/// ANI_IntrathPuncInjectSpeed
Property ANIIntrathPuncInjectSpeed As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = ANI_IntrathPuncInjectSpeed ];

/// ANI_IntrathPuncArachnoid
Property ANIIntrathPuncArachnoid As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ANI_IntrathPuncArachnoid ];

/// ANI_IntrathPuncOther
Property ANIIntrathPuncOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = ANI_IntrathPuncOther ];

/// ANI_IntrathCatheter
Property ANIIntrathCatheter As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = ANI_IntrathCatheter ];

/// ANI_IntrathCathPuncEffect
Property ANIIntrathCathPuncEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = ANI_IntrathCathPuncEffect ];

/// ANI_IntrathCathLen
Property ANIIntrathCathLen As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = ANI_IntrathCathLen ];

/// ANI_IntrathCathDirect
Property ANIIntrathCathDirect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = ANI_IntrathCathDirect ];

/// ANI_IntrathCathSpec
Property ANIIntrathCathSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ANI_IntrathCathSpec ];

/// ANI_IntrathCathIndwell
Property ANIIntrathCathIndwell As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = ANI_IntrathCathIndwell ];

/// ANI_IntrathCathInDate
Property ANIIntrathCathInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = ANI_IntrathCathInDate ];

/// ANI_IntrathCathInTime
Property ANIIntrathCathInTime As %Library.Time [ SqlColumnNumber = 37, SqlFieldName = ANI_IntrathCathInTime ];

/// ANI_IntrathCathInCtcp_Dr
Property ANIIntrathCathInCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = ANI_IntrathCathInCtcp_Dr ];

/// ANI_IntrathCathExtDate
Property ANIIntrathCathExtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = ANI_IntrathCathExtDate ];

/// ANI_IntrathCathExtTime
Property ANIIntrathCathExtTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = ANI_IntrathCathExtTime ];

/// ANI_IntrathCathExtCtcp_Dr
Property ANIIntrathCathExtCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = ANI_IntrathCathExtCtcp_Dr ];

/// ANI_IntrathCathOther
Property ANIIntrathCathOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = ANI_IntrathCathOther ];

/// ANI_IntrathAnaLevelTop
Property ANIIntrathAnaLevelTop As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = ANI_IntrathAnaLevelTop ];

/// ANI_IntrathAnaLevelBottom
Property ANIIntrathAnaLevelBottom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = ANI_IntrathAnaLevelBottom ];

/// ANI_IntrathToxicity
Property ANIIntrathToxicity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = ANI_IntrathToxicity ];

/// ANI_IntrathSpinal
Property ANIIntrathSpinal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = ANI_IntrathSpinal ];

/// ANI_IntrathSpinalOther
Property ANIIntrathSpinalOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = ANI_IntrathSpinalOther ];

/// ANI_IntrathEpidural
Property ANIIntrathEpidural As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = ANI_IntrathEpidural ];

/// ANI_IntrathEpidlTestAmt
Property ANIIntrathEpidlTestAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = ANI_IntrathEpidlTestAmt ];

/// ANI_IntrathEpiduralOther
Property ANIIntrathEpiduralOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = ANI_IntrathEpiduralOther ];

/// ANI_IntrathCaudal
Property ANIIntrathCaudal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = ANI_IntrathCaudal ];

/// ANI_IntrathCaudalPuncEffect
Property ANIIntrathCaudalPuncEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = ANI_IntrathCaudalPuncEffect ];

/// ANI_IntrathCaudalTestAmt
Property ANIIntrathCaudalTestAmt As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = ANI_IntrathCaudalTestAmt ];

/// ANI_IntrathCaudalOther
Property ANIIntrathCaudalOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = ANI_IntrathCaudalOther ];

/// ANI_IntrathOther
Property ANIIntrathOther As %Library.Float [ SqlColumnNumber = 55, SqlFieldName = ANI_IntrathOther ];

/// ANI_NerveBlock
Property ANINerveBlock As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = ANI_NerveBlock ];

/// ANI_NerveBlockType
Property ANINerveBlockType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = ANI_NerveBlockType ];

/// ANI_NerveBlockSite
Property ANINerveBlockSite As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = ANI_NerveBlockSite ];

/// ANI_NerveBlockPuncEffect
Property ANINerveBlockPuncEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = ANI_NerveBlockPuncEffect ];

/// ANI_NerveBlockToxicity
Property ANINerveBlockToxicity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = ANI_NerveBlockToxicity ];

/// ANI_NerveBlockEffect
Property ANINerveBlockEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = ANI_NerveBlockEffect ];

/// ANI_NerveBlockOther
Property ANINerveBlockOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = ANI_NerveBlockOther ];

/// ANI_General
Property ANIGeneral As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = ANI_General ];

/// ANI_GeneralType
Property ANIGeneralType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = ANI_GeneralType ];

/// ANI_GeneralInduce
Property ANIGeneralInduce As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = ANI_GeneralInduce ];

/// ANI_GeneralInduceType
Property ANIGeneralInduceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = ANI_GeneralInduceType ];

/// ANI_GeneralInduceEffect
Property ANIGeneralInduceEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = ANI_GeneralInduceEffect ];

/// ANI_GeneralInduceOther
Property ANIGeneralInduceOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = ANI_GeneralInduceOther ];

/// ANI_GeneralInhalation
Property ANIGeneralInhalation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = ANI_GeneralInhalation ];

/// ANI_GeneralInhalType
Property ANIGeneralInhalType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = ANI_GeneralInhalType ];

/// ANI_GeneralIntraven
Property ANIGeneralIntraven As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = ANI_GeneralIntraven ];

/// ANI_GeneralIntravenType
Property ANIGeneralIntravenType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = ANI_GeneralIntravenType ];

/// ANI_Intubation
Property ANIIntubation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = ANI_Intubation ];

/// ANI_IntubationAnestType
Property ANIIntubationAnestType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = ANI_IntubationAnestType ];

/// ANI_IntubationEffect
Property ANIIntubationEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = ANI_IntubationEffect ];

/// ANI_IntubationVision
Property ANIIntubationVision As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = ANI_IntubationVision ];

/// ANI_IntubationVisionType
Property ANIIntubationVisionType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = ANI_IntubationVisionType ];

/// ANI_IntubationInnerDiameter
Property ANIIntubationInnerDiameter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = ANI_IntubationInnerDiameter ];

/// ANI_IntubationTerminal
Property ANIIntubationTerminal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = ANI_IntubationTerminal ];

/// ANI_IntubationCuff
Property ANIIntubationCuff As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = ANI_IntubationCuff ];

/// ANI_IntubationRoute
Property ANIIntubationRoute As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = ANI_IntubationRoute ];

/// ANI_IntubationDepth
Property ANIIntubationDepth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = ANI_IntubationDepth ];

/// ANI_IntubationInDate
Property ANIIntubationInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 83, SqlFieldName = ANI_IntubationInDate ];

/// ANI_IntubationInTime
Property ANIIntubationInTime As %Library.Time [ SqlColumnNumber = 84, SqlFieldName = ANI_IntubationInTime ];

/// ANI_IntubationInCtcp_Dr
Property ANIIntubationInCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 85, SqlFieldName = ANI_IntubationInCtcp_Dr ];

/// ANI_IntubationExtIndicator
Property ANIIntubationExtIndicator As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = ANI_IntubationExtIndicator ];

/// ANI_IntubationExtDone
Property ANIIntubationExtDone As %Library.String [ SqlColumnNumber = 87, SqlFieldName = ANI_IntubationExtDone ];

/// ANI_IntubationExtDate
Property ANIIntubationExtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 88, SqlFieldName = ANI_IntubationExtDate ];

/// ANI_IntubationExtTime
Property ANIIntubationExtTime As %Library.Time [ SqlColumnNumber = 89, SqlFieldName = ANI_IntubationExtTime ];

/// ANI_IntubationExtCtcp_Dr
Property ANIIntubationExtCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 90, SqlFieldName = ANI_IntubationExtCtcp_Dr ];

/// ANI_IntubationExtTech
Property ANIIntubationExtTech As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = ANI_IntubationExtTech ];

/// ANI_IntubatLaryngomask
Property ANIIntubatLaryngomask As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 92, SqlFieldName = ANI_IntubatLaryngomask ];

/// ANI_IntubatLarymaskSize
Property ANIIntubatLarymaskSize As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 93, SqlFieldName = ANI_IntubatLarymaskSize ];

/// ANI_IntubatLarymaskSpec
Property ANIIntubatLarymaskSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = ANI_IntubatLarymaskSpec ];

/// ANI_IntubationOther
Property ANIIntubationOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = ANI_IntubationOther ];

/// ANI_GeneralRecovery
Property ANIGeneralRecovery As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 96, SqlFieldName = ANI_GeneralRecovery ];

/// ANI_GeneralRecovTech
Property ANIGeneralRecovTech As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = ANI_GeneralRecovTech ];

/// ANI_GeneralRecovDuration
Property ANIGeneralRecovDuration As %Library.Float [ SqlColumnNumber = 98, SqlFieldName = ANI_GeneralRecovDuration ];

/// ANI_GeneralRecovLocation
Property ANIGeneralRecovLocation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 99, SqlFieldName = ANI_GeneralRecovLocation ];

/// ANI_GeneralRecoveryOther
Property ANIGeneralRecoveryOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = ANI_GeneralRecoveryOther ];

/// ANI_GeneralOther
Property ANIGeneralOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 101, SqlFieldName = ANI_GeneralOther ];

Property ANITheatreTransferTo As %String [ SqlColumnNumber = 102, SqlFieldName = ANI_TheatreTransferTo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANI_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANI_General">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="ANI_GeneralInduce">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="ANI_GeneralInduceEffect">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="ANI_GeneralInduceOther">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="ANI_GeneralInduceSucc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANI_GeneralInduceType">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="ANI_GeneralInhalType">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="ANI_GeneralInhalation">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="ANI_GeneralIntraven">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="ANI_GeneralIntravenType">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="ANI_GeneralMark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANI_GeneralOther">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="ANI_GeneralRecovDuration">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="ANI_GeneralRecovLocation">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="ANI_GeneralRecovTech">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="ANI_GeneralRecovery">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="ANI_GeneralRecoveryOther">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="ANI_GeneralType">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="ANI_IntrathAnaLevelBottom">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ANI_IntrathAnaLevelTop">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ANI_IntrathCathDirect">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ANI_IntrathCathExtCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ANI_IntrathCathExtDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ANI_IntrathCathExtTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ANI_IntrathCathInCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ANI_IntrathCathInDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ANI_IntrathCathInTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ANI_IntrathCathIndwell">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ANI_IntrathCathLen">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ANI_IntrathCathOther">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ANI_IntrathCathPuncEffect">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ANI_IntrathCathSpec">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ANI_IntrathCathSuccess">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANI_IntrathCatheter">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ANI_IntrathCaudal">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ANI_IntrathCaudalOther">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="ANI_IntrathCaudalPuncEffect">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ANI_IntrathCaudalTestAmt">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ANI_IntrathEffect">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANI_IntrathEpidlTestAmt">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ANI_IntrathEpidural">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ANI_IntrathEpiduralOther">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ANI_IntrathOther">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="ANI_IntrathPos">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANI_IntrathPuncApproach">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANI_IntrathPuncArachnoid">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ANI_IntrathPuncBevelDirect">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ANI_IntrathPuncBleedAmt">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ANI_IntrathPuncDiffFeel">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ANI_IntrathPuncEffect">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANI_IntrathPuncInjectSpeed">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ANI_IntrathPuncNegComp">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ANI_IntrathPuncOther">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ANI_IntrathPuncPos">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ANI_IntrathPuncResist">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ANI_IntrathPuncSite">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANI_IntrathPuncSpec">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ANI_IntrathPuncSuccess">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANI_IntrathPuncture">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANI_IntrathSpinal">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ANI_IntrathSpinalOther">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ANI_IntrathToxicity">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ANI_IntrathType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANI_Intrathecal">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANI_IntrathecalMark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANI_IntubatLarymaskSize">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="ANI_IntubatLarymaskSpec">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="ANI_IntubatLaryngomask">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="ANI_Intubation">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="ANI_IntubationAnestType">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="ANI_IntubationCuff">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="ANI_IntubationDepth">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="ANI_IntubationEffect">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="ANI_IntubationExtCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="ANI_IntubationExtDate">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="ANI_IntubationExtDone">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="ANI_IntubationExtIndicator">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="ANI_IntubationExtTech">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="ANI_IntubationExtTime">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="ANI_IntubationInCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="ANI_IntubationInDate">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="ANI_IntubationInTime">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="ANI_IntubationInnerDiameter">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="ANI_IntubationMark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANI_IntubationOther">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="ANI_IntubationRoute">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="ANI_IntubationTerminal">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="ANI_IntubationVision">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="ANI_IntubationVisionType">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="ANI_NerveBlock">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="ANI_NerveBlockEffect">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="ANI_NerveBlockMark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANI_NerveBlockOther">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="ANI_NerveBlockPuncEffect">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="ANI_NerveBlockPuncSucc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANI_NerveBlockSite">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="ANI_NerveBlockToxicity">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="ANI_NerveBlockType">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="ANI_PostAnaMark">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANI_TheatreTransferTo">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Global>^DHCANOPArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_OPArrange.OPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ANI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_OPArrange.OPA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANAnaestItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
