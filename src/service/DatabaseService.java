package service;

import util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

public class DatabaseService {
    public void insertDetectorNotFullCharge(String serial_number,
                                            String installation_location,
                                            double charge_lvl,
                                            int status) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL add_detector(?, ?, ?, ?)}")) {
            cstmt.setString(1, serial_number);
            cstmt.setString(2, installation_location);
            cstmt.setDouble(3, charge_lvl);
            cstmt.setInt(4, status);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            while (rs.next()) {
                System.out.println("Датчик добавлен\n");
                System.out.println("Серийный номер: " + rs.getString(1));
                System.out.println("Место установки: " + rs.getString(2));
                System.out.println("Уровень заряда: " + rs.getDouble(3));
                System.out.println("Состояние датчика: " + rs.getString(4));
            }
        }
    }

    public void insertDetectorWthFullCharge(String serial_number,
                                            String installation_location,
                                            int status) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL add_detector_with_full_charge(?, ?, ?)}")) {
            cstmt.setString(1, serial_number);
            cstmt.setString(2, installation_location);
            cstmt.setInt(3, status);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            while (rs.next()) {
                System.out.println("Датчик с полным зарядом добавлен\n");
                System.out.println("Серийный номер: " + rs.getString(1));
                System.out.println("Место установки: " + rs.getString(2));
                System.out.println("Состояние датчика: " + rs.getString(3));
            }
        }
    }

    public void deleteDetector(String serial_number) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL delete_detector(?)}")) {
            cstmt.setString(1, serial_number);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            while (rs.next()) {
                System.out.println("Датчик удален\n");
                System.out.println("Серийный номер: " + rs.getString(1));
                System.out.println("Место установки: " + rs.getString(2));
                System.out.println("Состояние датчика: " + rs.getString(3));
            }
        }
    }

    public void changeDetector(String serial_number,
                               String installation_location,
                               double charge_lvl,
                               int status) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL change_detector(?, ?, ?, ?)}")) {
            cstmt.setString(1, serial_number);
            cstmt.setString(2, installation_location);
            cstmt.setDouble(3, charge_lvl);
            cstmt.setInt(4, status);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            System.out.println("Датчик Изменен\n");
            while (rs.next()) {
                System.out.println("Серийный номер: " + rs.getString(1));
                System.out.println("Место установки: " + rs.getString(2));
                System.out.println("Состояние датчика: " + rs.getDouble(3));
                System.out.println("Состояние датчика: " + rs.getString(4) + "\n");
            }
        }
    }

    public void insertSignal(String signal_time,
                             String detector_serial_number,
                             int type_of_signal) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL add_signal(?, ?, ?)}")) {
            Timestamp timestamp = convertStringToTimestamp(signal_time);
            cstmt.setTimestamp(1, timestamp);
            cstmt.setString(2, detector_serial_number);
            cstmt.setInt(3, type_of_signal);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            System.out.println("Сигнал добавлен\n");
            while (rs.next()) {
                System.out.println("Дата и время сигнала: " + rs.getTimestamp(1));
                System.out.println("Серийный номер датчика: " + rs.getString(2));
                System.out.println("Тип сигнала: " + rs.getInt(3));
            }
        }
    }

    public void deleteSignal(String signal_time,
                             String detector_serial_number,
                             int type_of_signal) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL delete_signal(?, ?, ?)}")) {
            Timestamp timestamp = convertStringToTimestamp(signal_time);
            cstmt.setTimestamp(1, timestamp);
            cstmt.setString(2, detector_serial_number);
            cstmt.setInt(3, type_of_signal);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            System.out.println("Сигнал удален\n");
            while (rs.next()) {
                System.out.println("Дата и время сигнала: " + rs.getTimestamp(1));
                System.out.println("Серийный номер датчика: " + rs.getString(2));
                System.out.println("Тип сигнала: " + rs.getInt(3));
            }
        }
    }

    public void changeSignal(int id,
                             String signal_time,
                             String detector_serial_number,
                             int type_of_signal) throws Exception {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL change_signal(?, ?, ?, ?)}")) {
            Timestamp timestamp = convertStringToTimestamp(signal_time);
            cstmt.setInt(1, id);
            cstmt.setTimestamp(2, timestamp);
            cstmt.setString(3, detector_serial_number);
            cstmt.setInt(4, type_of_signal);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            System.out.println("Сигнал изменен\n");
            while (rs.next()) {
                System.out.println("ID сигнала: " + rs.getInt(1));
                System.out.println("Время: " + rs.getTimestamp(2));
                System.out.println("Серийный номер датчика: " + rs.getString(3));
                System.out.println("Тип сигнала: " + rs.getInt(4) + "\n");
            }
        }
    }

    public void get_info_about_detector_per_date(String str_date) throws Exception {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL info_about_det_per_date(?)}")) {
            Date date = Date.valueOf(str_date);
            cstmt.setDate(1, date);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            System.out.println("Информация о датчике за " + date + "\n");
            while (rs.next()) {
                System.out.println("Время: " + rs.getTime(1));
                System.out.println("Серийный номер датчика: " + rs.getString(2));
                System.out.println("Операция: " + rs.getString(3));
                System.out.println("Новые значения: " + rs.getString(4));
                System.out.println("Старые значения: " + rs.getString(5) + "\n");
            }
        }
    }

    public void get_info_about_signals_per_interval(String first_time, String second_time) throws Exception {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL info_about_signal_per_interval(?, ?)}")) {
            Timestamp timestamp1 = convertStringToTimestamp(first_time);
            Timestamp timestamp2 = convertStringToTimestamp(second_time);
            cstmt.setTimestamp(1, timestamp1);
            cstmt.setTimestamp(2, timestamp2);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            System.out.println("Информация о датчике c " + first_time + " по " + second_time + "\n");
            while (rs.next()) {
                System.out.println("Время: " + rs.getTimestamp(1));
                System.out.println("Серийный номер датчика: " + rs.getString(2));
                System.out.println("Тип сигнала : " + rs.getString(3) +"\n");
            }
        }
    }
    public void receive_signal(String text) throws Exception {
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall("{CALL receive_signal(?)}")) {
            cstmt.setString(1, text);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
            System.out.println("Принят сигнал" + "\n");
            while (rs.next()) {
                System.out.println("Время: " + rs.getTimestamp(1));
                System.out.println("Серийный номер датчика: " + rs.getString(2));
                System.out.println("Уровень заряда: " + rs.getDouble(3));
                System.out.println("Тип сигнала: " + rs.getInt(4) +"\n");
            }
        }
    }


    static Timestamp convertStringToTimestamp(String strDate) {
        final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return Optional.ofNullable(strDate)
                .map(str -> LocalDateTime.parse(str, formatter))
                .map(Timestamp::valueOf)
                .orElse(null);
    }
}
