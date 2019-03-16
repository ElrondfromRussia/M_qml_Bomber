#ifndef MYGAME_H
#define MYGAME_H

#include <QObject>
#include <QVector>
#include <QVariant>

class MyGame : public QObject
{
    Q_OBJECT
public:
    explicit MyGame(QObject *parent = 0);

signals:
    void go_new();
    void reset();
    void make_cell(QVariant, QVariant);
    void fill_cell(QVariant, QVariant);
    void set_bombs(QVariant);
    void set_size(QVariant);

public slots:
    void on_new_Game();
    int on_is_Bomb(int index);
    int on_count_Bobms(int index);
    void make_matrix();
    void on_check_for_bombs(int ind, int filling);
    void on_apply_settings(int, int);
protected:
    QObject *viewer;
private:
    QVector<int> bombs_inds;
    int size;
    int bombs;
};

#endif // MYGAME_H
