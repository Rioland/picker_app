import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickrr_app/src/blocs/authentication/bloc.dart';
import 'package:pickrr_app/src/blocs/business/available_riders/available_riders_bloc.dart';
import 'package:pickrr_app/src/blocs/business/business_status/bloc.dart';
import 'package:pickrr_app/src/blocs/driver/orders/bloc.dart';
import 'package:pickrr_app/src/blocs/ride/orders/bloc.dart';
import 'package:pickrr_app/src/helpers/custom_route.dart';
import 'package:pickrr_app/src/models/user.dart';
import 'package:pickrr_app/src/screens/auth/complete_profile_form.dart';
import 'package:pickrr_app/src/screens/auth/login.dart';
import 'package:pickrr_app/src/screens/business/application.dart';
import 'package:pickrr_app/src/screens/business/business_details.dart';
import 'package:pickrr_app/src/screens/business/drivers/application.dart';
import 'package:pickrr_app/src/screens/business/password_prompt.dart';
import 'package:pickrr_app/src/screens/business/business_home.dart';
import 'package:pickrr_app/src/screens/business/tabs/business_drivers/business_driver_activity.dart';
import 'package:pickrr_app/src/screens/business/tabs/business_drivers/driver_activities_details.dart';
import 'package:pickrr_app/src/screens/business/tabs/ride/assign_driver.dart';
import 'package:pickrr_app/src/screens/driver/onboard.dart';
import 'package:pickrr_app/src/screens/driver/order_history.dart';
import 'package:pickrr_app/src/screens/home.dart';
import 'package:pickrr_app/src/screens/onboard.dart';
import 'package:pickrr_app/src/screens/driver/main_activity.dart';
import 'package:pickrr_app/src/screens/driver/driver_form.dart';
import 'package:pickrr_app/src/screens/ride/review_order.dart';
import 'package:pickrr_app/src/screens/ride/ride_details.dart';
import 'package:pickrr_app/src/screens/ride/ride_history.dart';
import 'package:pickrr_app/src/screens/ride/track_deliveries.dart';
import 'package:pickrr_app/src/screens/terms.dart';
import 'package:pickrr_app/src/screens/tried.dart';
import 'package:pickrr_app/src/screens/user_profile.dart';
import 'package:pickrr_app/src/widgets/rate_driver.dart';

class Routes {
  static dynamic route() {
    return {
      '/': (BuildContext context) => BlocProvider<AuthenticationBloc>(
          create: (_) =>
              AuthenticationBloc()..add(AuthenticationEvent.APP_STARTED),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (_, state) {
            return homePage(context, state);
          })),
    };
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "BusinessHomePage":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => MultiBlocProvider(providers: [
                  BlocProvider<AuthenticationBloc>(
                      create: (_) => AuthenticationBloc()
                        ..add(AuthenticationEvent.AUTHENTICATED)),
                  BlocProvider<BusinessStatusBloc>(
                      create: (_) => BusinessStatusBloc()),
                ], child: Scaffold(body: BusinessHomePage())));
      case "BusinessApplication":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => BusinessApplication());
      case "PasswordPrompt":
        bool isNewBusiness;
        if (pathElements.length > 2) {
          isNewBusiness = pathElements[2].toLowerCase() == 'true';
        }
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => PasswordPrompt(isNewBusiness));
      case "Onboard":
        return CustomRoute<bool>(builder: (BuildContext context) => Onboard());
      case "DriversHomePage":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => MultiBlocProvider(providers: [
                  BlocProvider<AuthenticationBloc>(
                      create: (_) => AuthenticationBloc()
                        ..add(AuthenticationEvent.AUTHENTICATED))
                ], child: DriverTabs()));
      case "Login":
        return CustomRoute<bool>(
            fullscreenDialog: true,
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc(), child: Login()));
      case "DriverOnboard":
        return CustomRoute<bool>(
            fullscreenDialog: true,
            builder: (BuildContext context) => DriverOnboard());
      case "DriverApplication":
        return CustomRoute<bool>(
            builder: (BuildContext context) => DriverApplication());
      case "CompleteProfileDetails":
        return CustomRoute<bool>(
            fullscreenDialog: true,
            builder: (BuildContext context) => CompleteProfileForm());
      case "ProfileDetails":
        return CustomRoute<bool>(
            fullscreenDialog: true,
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc()
                  ..add(AuthenticationEvent.AUTHENTICATED),
                child: UserProfile()));
      case "Terms":
        return CustomRoute<bool>(
            fullscreenDialog: true,
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc()
                  ..add(AuthenticationEvent.AUTHENTICATED),
                child: Terms()));
      case "ReviewOrderPage":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc()
                  ..add(AuthenticationEvent.AUTHENTICATED),
                child: ReviewOrder(settings.arguments)));
      case "RideDetails":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc()
                  ..add(AuthenticationEvent.AUTHENTICATED_NO_UPDATE),
                child: RideDetails(settings.arguments)));
      case "RideRatingDialog":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) =>
                RideRatingDialog(settings.arguments));
      case "RideHistory":
        return CustomRoute<bool>(
            builder: (BuildContext context) => BlocProvider<RideOrdersBloc>(
                create: (_) => RideOrdersBloc()..add(OrdersFetched()),
                child: RideHistory()));
      case "RiderHistory":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                BlocProvider<RiderOrdersHistoryBloc>(
                    create: (_) =>
                        RiderOrdersHistoryBloc()..add(RiderOrdersFetched()),
                    child: RiderOrderHistory()));
      case "TrackDeliveries":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => TrackDeliveries());
      case "HomePage":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc()
                  ..add(AuthenticationEvent.AUTHENTICATED),
                child: Home(arguments: settings.arguments)));
      case "Tried":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc()
                  ..add(AuthenticationEvent.AUTHENTICATED),
                child: Tried(arguments: settings.arguments)));
      case "BusinessDetails":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
                create: (_) => AuthenticationBloc()
                  ..add(AuthenticationEvent.AUTHENTICATED),
                child: BusinessProfile()));
      case "AssignDriver":
        int rideId;
        if (pathElements.length > 2) {
          rideId = int.parse(pathElements[2]);
        } else {
          return onUnknownRoute(RouteSettings(name: '/Unknown'));
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                BlocProvider<AvailableRidersBloc>(
                    create: (_) => AvailableRidersBloc(),
                    child: AssignDriver(rideId)));
      case "NewBusinessRiderApplication":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => NewRiderApplication());
      case "DriverActivities":
        int riderId;
        if (pathElements.length > 2) {
          riderId = int.parse(pathElements[2]);
        } else {
          return onUnknownRoute(RouteSettings(name: '/Unknown'));
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) => BusinessDriverActivity(riderId));
      case "DriverActivitiesDetails":
        int riderId;
        if (pathElements.length > 2) {
          riderId = int.parse(pathElements[2]);
        } else {
          return onUnknownRoute(RouteSettings(name: '/Unknown'));
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                DriverActivitiesDetails(riderId));
      default:
        return onUnknownRoute(RouteSettings(name: '/Unknown'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('${settings.name.split('/')[1]} Not available...'),
        ),
      ),
    );
  }
}

Widget homePage(BuildContext context, AuthenticationState state) {
  if (state is UnDetermined || state is NonLoggedIn) {
    return Onboard();
  }

  User user = state.props[0];
  if (!user.isCompleteDetails) {
    return CompleteProfileForm();
  }

  if (user.isDriver) {
    return DriverTabs();
  }

  if (user.isBusiness) {
    return PasswordPrompt(user.isNewBusiness);
  }

  return Home();
}
