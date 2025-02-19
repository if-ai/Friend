import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/ble/blur/blur_widget.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'connected_model.dart';
export 'connected_model.dart';

class ConnectedWidget extends StatefulWidget {
  const ConnectedWidget({
    super.key,
    required this.btdevice,
  });

  final dynamic btdevice;

  @override
  State<ConnectedWidget> createState() => _ConnectedWidgetState();
}

class _ConnectedWidgetState extends State<ConnectedWidget> {
  late ConnectedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConnectedModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'connected'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('CONNECTED_PAGE_connected_ON_INIT_STATE');
      logFirebaseEvent('connected_custom_action');
      _model.hasWrite = await actions.ble0connectDevice(
        BTDeviceStruct.maybeFromMap(widget.btdevice!)!,
      );
      logFirebaseEvent('connected_wait__delay');
      await Future.delayed(const Duration(milliseconds: 1000));
      while (_model.connectedFraction < 1.0) {
        logFirebaseEvent('connected_update_page_state');
        setState(() {
          _model.connectedFraction = _model.connectedFraction + .01;
        });
        logFirebaseEvent('connected_wait__delay');
        await Future.delayed(const Duration(milliseconds: 25));
      }
      logFirebaseEvent('connected_navigate_to');

      context.pushNamed(
        'connectDevice',
        queryParameters: {
          'btdevice': serializeParam(
            widget.btdevice,
            ParamType.JSON,
          ),
        }.withoutNulls,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: Stack(
          children: [
            wrapWithModel(
              model: _model.blurModel,
              updateCallback: () => setState(() {}),
              child: BlurWidget(),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_box,
                    color: FlutterFlowTheme.of(context).secondary,
                    size: 40.0,
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      'Device Connected',
                      style:
                          FlutterFlowTheme.of(context).headlineLarge.override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .headlineLargeFamily,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .headlineLargeFamily),
                              ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      'Simply turn your device and it will start\ndocumenting your memories automatically.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleSmallFamily,
                            color: Color(0x9AFFFFFF),
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).titleSmallFamily),
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        logFirebaseEvent('CONNECTED_PAGE_CONTINUE_BTN_ON_TAP');
                        logFirebaseEvent('Button_navigate_to');

                        context.pushNamed('PermissionPage');
                      },
                      text: 'Continue',
                      options: FFButtonOptions(
                        height: 60.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            40.0, 0.0, 40.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'SF Pro Display',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey('SF Pro Display'),
                                ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).secondary,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
