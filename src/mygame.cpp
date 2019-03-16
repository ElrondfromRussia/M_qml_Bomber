#include "mygame.h"
#include "stdio.h"
#include <math.h>
#include <ctime>
#include <QDebug>
#include <QSharedPointer>
#include <QFile>
#include <QThread>
#include <QPixmap>


MyGame::MyGame(QObject *QMLObject):
    viewer(QMLObject)
{
    emit go_new();
    size = 9;
    bombs = 10;
    connect(viewer, SIGNAL(apply_settings(int, int)), this, SLOT(on_apply_settings(int, int)));
    connect(viewer, SIGNAL(check_cell_now(int, int)), this, SLOT(on_check_for_bombs(int, int)));
    connect(viewer, SIGNAL(go_new()), this, SLOT(on_new_Game()));
    connect(this, SIGNAL(reset()), viewer, SLOT(on_reset()));
    connect(this, SIGNAL(set_bombs(QVariant)), viewer, SLOT(on_set_bombs(QVariant)));
    connect(this, SIGNAL(set_size(QVariant)), viewer, SLOT(on_set_size(QVariant)));
    connect(this, SIGNAL(make_cell(QVariant, QVariant)), viewer, SLOT(on_make_cell(QVariant, QVariant)));
    connect(this, SIGNAL(fill_cell(QVariant, QVariant)), viewer, SLOT(on_fill_cellsss(QVariant, QVariant)));

    on_new_Game();
}

void MyGame::on_new_Game()
{
    make_matrix();
    emit set_bombs(bombs);
    emit set_size(size);
    emit reset();
}

void MyGame::on_check_for_bombs(int ind, int filling)
{
    if(on_is_Bomb(ind))
    {
        make_cell(QVariant(-1), QVariant(ind));
    }
    else
    {
        if(!filling)
            make_cell(QVariant(QString("%1").arg(on_count_Bobms(ind))), QVariant(ind));
        else
            fill_cell(QVariant(QString("%1").arg(on_count_Bobms(ind))), QVariant(ind));
    }
}


void MyGame::on_apply_settings(int sizee, int bomb_num)
{
    size = sizee;
    bombs = bomb_num;
    on_new_Game();
}

int MyGame::on_is_Bomb(int index)
{
    return bombs_inds.contains(index);
}

int MyGame::on_count_Bobms(int index)
{
    int res = 0;

    res += bombs_inds.contains(index + size - 1) * ((index-1) % size != 0 && index < (size*(size -1)+1));
    res += bombs_inds.contains(index + size + 1) * ((index) % size != 0 && index < (size*(size -1)+1));
    res += bombs_inds.contains(index + size) * (index < (size*(size -1)+1));

    res += bombs_inds.contains(index - size - 1) * ((index-1) % size != 0 && index > size);
    res += bombs_inds.contains(index - size + 1) * ((index) % size != 0 && index > size);
    res += bombs_inds.contains(index - size) * (index > size);

    res += bombs_inds.contains(index  - 1) * ((index-1) % size != 0);
    res += bombs_inds.contains(index  + 1) * ((index) % size != 0);

    return res;
}

void MyGame::make_matrix()
{
    srand(time(0));
    bombs_inds.clear();
    int bom = bombs;
    if(bombs <= size*size)
    {
        while(bom)
        {
            int res = rand() % (size*size) + 1;
            if(!bombs_inds.contains(res))
            {
                bombs_inds.push_back(res);
                bom--;
            }
        }
    }
}

