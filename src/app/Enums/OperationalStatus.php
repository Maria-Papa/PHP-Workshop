<?php

declare(strict_types=1);

namespace App\Enums;

enum OperationalStatus: string
{
    case OPEN               = 'open';
    case CLOSED             = 'closed';
    case TEMPORARILY_CLOSED = 'temporarily_closed';

    public function label(): string
    {
        return match ($this) {
            self::OPEN               => 'Open',
            self::CLOSED             => 'Closed',
            self::TEMPORARILY_CLOSED => 'Temporarily Closed',
        };
    }
}
